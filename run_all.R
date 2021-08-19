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

source('header.R')

source("01_load.R")
#repo BC_HumanFootprint generates a weighted surface based on McRae et al 2016
#uses Provincial CE disturbance layer and consolidated roads
#file should be in the 'SpatialDir' directory and named 'resistance_surface'

#Clips input too AOI - current options include:
#AOI <- ws %>%
#  filter(SUB_SUB_DRAINAGE_AREA_NAME == "Bulkley")
AOI <- BCr
#AOI <- ESI

#resolution of analysis - default is 50km moving window after McRae et al 2016
#1 ha cells requires 500 cells to have a 50km (50,000m) radius
OmniRadius<-50 #in km
pixSize<-10 #in hectares - changes resolution of grids but will maintain OmniRadius
BlockSize<-3 #odd number - looks at blocks of 9 pixels instead of 1
source("02_clean.R")

#set run directory for omniscape
RunDir<-"Test43"

#resistance_surface and source_suface  - are a potentially aggregated or clipped file from original surfaces
resistance_surface<- resistance_surface_AOI
source_surface<-source_surface_AOI

#Write out surfaces so that Omniscape can read them
writeRaster(resistance_surface, filename=file.path(ConnDir,'resistance_surface.tif'), format="GTiff", overwrite=TRUE)
writeRaster(source_surface, filename=file.path(ConnDir,'source_surface.tif'), format="GTiff", overwrite=TRUE)

#run as tiles? for larger rasters - still testing
NumTiles<-1
#source("03_analysis_tiles.R")

source("03_Omni_analysis.R")

source("04_output.R")

cellStats(flow_potential,range)

