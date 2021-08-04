library(sf)
library(dplyr)
library(readr)
library(raster)
library(bcmaps)
library(rgdal)
library(fasterize)
library(readxl)
library(mapview)

OutDir <- 'out'
dataOutDir <- file.path(OutDir,'data')
tileOutDir <- file.path(dataOutDir,'tile')
figsOutDir <- file.path(OutDir,'figures')
spatialOutDir <- file.path(OutDir,'spatial')
SpatialDir <- file.path('data','spatial')
ConnDir <- file.path(spatialOutDir,'ConnData')
DataDir <- 'data'
WetspatialDir <- file.path('/Users/darkbabine/Dropbox (BVRC)/Projects/ESI/Wetlands/Assessment/Data')
WetzinkData <- file.path('/Users/darkbabine/Dropbox (BVRC)/Projects/LUP/Wetzinkwa/Data/ColinCCWebAppData')
RefugiaSpatialDir <- file.path('/Users/darkbabine/Dropbox (BVRC)/Projects/ClimateChange/BiodiversityCC/ClimateRefugia')
ESIDir <- file.path('/Users/darkbabine/Dropbox (BVRC)/Projects/ESI')


dir.create(file.path(OutDir), showWarnings = FALSE)
dir.create(file.path(dataOutDir), showWarnings = FALSE)
dir.create(file.path(tileOutDir), showWarnings = FALSE)
dir.create(file.path(figsOutDir), showWarnings = FALSE)
dir.create(DataDir, showWarnings = FALSE)
dir.create("tmp", showWarnings = FALSE)
dir.create("tmp/AOI", showWarnings = FALSE)
dir.create(file.path(spatialOutDir), showWarnings = FALSE)
dir.create(file.path(ConnDir), showWarnings = FALSE)

#OmniDir <- file.path('/Users/darkbabine/ProjectLibrary/omni')




