# Copyright 2021 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#Resistence and Source rasters from Omni used for testing
#layer <- raster('/Users/darkbabine/ProjectLibrary/omni/test/input/resistance.asc')
#sites <- raster('/Users/darkbabine/ProjectLibrary/omni/test/input/source.asc')

#Rasterize the Province for subsequent masking
# bring in BC boundary
bc <- bcmaps::bc_bound()
Prov_crs<-crs(bc)

#Provincial Raster to place rasters in the same reference
BCr_file <- file.path(spatialOutDir,"BCr.tif")
if (!file.exists(BCr_file)) {
  BCr <- fasterize(bcmaps::bc_bound_hres(class='sf'),ProvRast)
  writeRaster(BCr, filename=BCr_file, format="GTiff", overwrite=TRUE)
  ProvRast<-raster(nrows=15744, ncols=17216, xmn=159587.5, xmx=1881187.5,
                   ymn=173787.5, ymx=1748187.5,
                   crs=Prov_crs,
                   res = c(100,100), vals = 1)
  writeRaster(ProvRast, filename=file.path(spatialOutDir,'ProvRast'), format="GTiff", overwrite=TRUE)
} else {
  BCr <- raster(BCr_file)
  ProvRast<-raster(file.path(spatialOutDir,'ProvRast.tif'))
}

######
#Conservancies for source layer
#can modify to include other conservancies and intact lands
parks2017R_file <- file.path(spatialOutDir,"parks2017R.tif")
if (!file.exists(parks2017R_file)) {
  parks2017i<-readOGR(file.path(SpatialDir,"ConservationAreas/designated_lands_dissolved_2017-06-27/designated_lands_dissolved.shp"),"designated_lands_dissolved") %>%
    as('sf') %>%
    st_transform(3005)
  parkCats<-data.frame(CATEGORY=unique(parks2017i$CATEGORY), CatN=1:4)
  parks2017<-parks2017i %>%
    left_join(parkCats) %>%
    dplyr::filter(CatN==1) #rasterize only PPA
  parks2017R<-fasterize(parks2017,ProvRast,field="CatN")
  writeRaster(parks2017R, filename=file.path(spatialOutDir,"parks2017R.tif"), format="GTiff", overwrite=TRUE)
  saveRDS(parks2017,file='tmp/parks2017')
} else {
  parks2017R<-raster(file.path(spatialOutDir,"parks2017R.tif"), format="GTiff")
  parks2017<-readRDS(file='tmp/parks2017')
}

#######
#Potential AOIs for testing
#ESI boundary - for testing, etc.
ESI_file <- file.path("tmp/ESI")
if (!file.exists(ESI_file)) {
  #Load ESI boundary
  ESIin <- read_sf(file.path(ESIDir,'Data/Skeena_ESI_Boundary'), layer = "ESI_Skeena_Study_Area_Nov2017") %>%
    st_transform(3005)
  ESI <- st_cast(ESIin, "MULTIPOLYGON")
  saveRDS(ESI, file = ESI_file)
} else
  ESI<-readRDS(file = ESI_file)

#Ecosections
EcoS_file <- file.path("tmp/EcoS")
ESin <- read_sf(file.path(SpatialDir,'Ecosections/Ecosections.shp')) %>%
  st_transform(3005)
EcoS <- st_cast(ESin, "MULTIPOLYGON")
saveRDS(EcoS, file = EcoS_file)

#SkeenaSalmonStudyBoundary
SalmS_file <- file.path("tmp/SalmS")
SalmSin <- read_sf(file.path(SpatialDir,'SkeenaSalmonStudyBd/SkeenaSalmonStudyBd.shp')) %>%
  st_transform(3005)
SalmS <- st_cast(SalmSin, "MULTIPOLYGON")
saveRDS(SalmS, file = SalmS_file)

# Download BEC - # Gets bec_sf zone shape
BEC_file <- 'tmp/bec_sf'
if (!file.exists(BEC_file)) {
  bec_sf <- bec(class = "sf")# %>%
#st_intersection(study_area)
saveRDS(bec_sf, file = "tmp/bec_sf")
} else {
  bec_sf<-readRDS(file='tmp/bec_sf')
}

ws <- get_layer("wsc_drainages", class = "sf") %>%
  dplyr::select(SUB_DRAINAGE_AREA_NAME, SUB_SUB_DRAINAGE_AREA_NAME) %>%
  dplyr::filter(SUB_DRAINAGE_AREA_NAME %in% c("Nechako", "Skeena - Coast"))
st_crs(ws)<-3005
saveRDS(ws, file = "tmp/ws")
write_sf(ws, file.path(spatialOutDir,"ws.gpkg"))




