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
bc <- bcmaps::bc_bound(ask = F)
Prov_crs<-raster::crs(bc)

#Provincial Raster to place rasters in the same reference
BCr_file <- file.path(spatialOutDir,"BCr.tif")
if (!file.exists(BCr_file)) {
  BC<-bcmaps::bc_bound_hres(ask = F)
  saveRDS(BC,file='tmp/BC')
  ProvRast<-raster(nrows=15744, ncols=17216, xmn=159587.5, xmx=1881187.5,
                   ymn=173787.5, ymx=1748187.5,
                   crs=Prov_crs,
                   res = c(100,100), vals = 1)
  BCr <- fasterize(bcmaps::bc_bound_hres(),ProvRast)
  writeRaster(BCr, filename=BCr_file, format="GTiff", overwrite=TRUE)
  writeRaster(ProvRast, filename=file.path(spatialOutDir,'ProvRast'), format="GTiff", overwrite=TRUE)
} else {
  BCr <- raster(BCr_file)
  BC <-readRDS('tmp/BC')
  ProvRast<-raster(file.path(spatialOutDir,'ProvRast.tif'))
}

#######
#Potential AOIs for testing
#Ecosections
# EcoS_file <- file.path("tmp/EcoS")
# ESin <- read_sf(file.path(SpatialDir,'Ecosections/Ecosections.shp')) %>%
#   st_transform(3005)
# EcoS <- st_cast(ESin, "MULTIPOLYGON")
# saveRDS(EcoS, file = EcoS_file)

#Watersheds
ws <- get_layer("wsc_drainages") %>%#, class = "sf")
  dplyr::select(SUB_DRAINAGE_AREA_NAME, SUB_SUB_DRAINAGE_AREA_NAME) %>%
  dplyr::filter(SUB_DRAINAGE_AREA_NAME %in% c("Nechako", "Skeena - Coast"))
st_crs(ws)<-3005
saveRDS(ws, file = "tmp/ws")
write_sf(ws, file.path(spatialOutDir,"ws.gpkg"))





