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

normalized_cum_currmap <- raster(file.path(ConnDir,RunDir,'normalized_cum_currmap.tif'))
cum_currmap <- raster(file.path(ConnDir,RunDir,'cum_currmap.tif'))
flow_potential <- raster(file.path(ConnDir,RunDir,'flow_potential.tif'))

plot(normalized_cum_currmap)
plot(cum_currmap)
plot(flow_potential)

cellStats(flow_potential,range)
cellStats(normalized_cum_currmap,range)

#evaluate distribution of data
hist(normalized_cum_currmap,
     breaks=1000,
     main = "Distribution of normalized_cum_currmap values",
     xlab = "Value", ylab = "Frequency",
     col = "springgreen",)
histinfo <- hist(normalized_cum_currmap,breaks=1000)

m <- c(0,1,1, 1,1.25,2, 1.25,1.5,3, 1.5,1.75,4, 1.75,2,5, 2,9999,6)
rclmat <- matrix(m, ncol=3, byrow=TRUE)
norm_cum_currManual <- reclassify(normalized_cum_currmap, rclmat)
writeRaster(norm_cum_currManual, filename=file.path(spatialOutDir,'norm_cum_currManual'), format="GTiff", overwrite=TRUE)

#Density plot
normalized_cum_currmapV<-as.vector(normalized_cum_currmap)
normalized_cum_currmapV<-normalized_cum_currmapV[!is.na(normalized_cum_currmapV)]
plot(density(normalized_cum_currmapV))
#calculate percentiles
#quantile(normalized_cum_currmapV, probs = seq(.1, 1, by = .1))
NormQ<-quantile(normalized_cum_currmapV)
#make a classification table based on quantiles
m<- c(NormQ[1],NormQ[2],1, NormQ[2],NormQ[3],2, NormQ[3],NormQ[4],3, NormQ[4],NormQ[5],4)
#m <- c(0,1,1, 1,1.25,2, 1.25,1.5,3, 1.5,1.75,4, 1.75,2,5, 2,9999,6)
rclmat <- matrix(m, ncol=3, byrow=TRUE)
norm_cum_curr <- reclassify(normalized_cum_currmap, rclmat)
writeRaster(norm_cum_curr, filename=file.path(spatialOutDir,'norm_cum_curr'), format="GTiff", overwrite=TRUE)

#Smooth data
norm_cum_currSM1 <- focal(norm_cum_curr, w=matrix(1, 1, 1), mean)
writeRaster(norm_cum_currSM1, filename=file.path(spatialOutDir,'norm_cum_currSM1'), format="GTiff", overwrite=TRUE)
#reclassify
m <- c(0,1,1, 1,2,2, 2,3,3, 3,4,4)
rclmat <- matrix(m, ncol=3, byrow=TRUE)
norm_cum_currSM1rcls <- reclassify(norm_cum_currSM1, rclmat)
writeRaster(norm_cum_currSM1rcls, filename=file.path(spatialOutDir,'norm_cum_currSM1rcls'), format="GTiff", overwrite=TRUE)

norm_cum_currSM3 <- focal(norm_cum_curr, w=matrix(1, 3, 3), mean)
writeRaster(norm_cum_currSM3, filename=file.path(spatialOutDir,'norm_cum_currSM3'), format="GTiff", overwrite=TRUE)
#reclassify
m <- c(0,1,1, 1,2,2, 2,3,3, 3,4,4)
rclmat <- matrix(m, ncol=3, byrow=TRUE)
norm_cum_currSM3rcls <- reclassify(norm_cum_currSM3, rclmat)
writeRaster(norm_cum_currSM3rcls, filename=file.path(spatialOutDir,'norm_cum_currSM3rcls'), format="GTiff", overwrite=TRUE)
#Nope
norm_cum_currSMdisag <- disaggregate(norm_cum_curr, 5)
writeRaster(norm_cum_currSMdisag, filename=file.path(spatialOutDir,'norm_cum_currSMdisag'), format="GTiff", overwrite=TRUE)

#Use clump, then find units with only 1 member - make a new raster then assign values based on
#largest neighbour?
norm_cum_currClump<-clump(norm_cum_curr, filename="", directions=8, gaps=TRUE)
writeRaster(norm_cum_currClump, filename=file.path(spatialOutDir,'norm_cum_currClump'), format="GTiff", overwrite=TRUE)

#################
# Flow potential - to support the intact mapping
#Density plot
flow_potentialV<-as.vector(flow_potential)
flow_potentialV<-flow_potentialV[!is.na(flow_potentialV)]
plot(density(flow_potentialV))

#quantile(normalized_cum_currmapV, probs = seq(.1, 1, by = .1))
NormQ<-quantile(flow_potential)
#make a classification table based on quantiles
m<- c(0,NormQ[1],0, NormQ[1], NormQ[2],1, NormQ[2],NormQ[3],2, NormQ[3],NormQ[4],3, NormQ[4],NormQ[5],4)
rclmat <- matrix(m, ncol=3, byrow=TRUE)
flow_pot <- reclassify(flow_potential, rclmat)
writeRaster(flow_pot, filename=file.path(spatialOutDir,'flow_pot'), format="GTiff", overwrite=TRUE)

#Smooth data
norm_cum_currSM1 <- focal(norm_cum_curr, w=matrix(1, 1, 1), mean)
writeRaster(norm_cum_currSM1, filename=file.path(spatialOutDir,'norm_cum_currSM1'), format="GTiff", overwrite=TRUE)
#reclassify
m <- c(0,1,1, 1,2,2, 2,3,3, 3,4,4)
rclmat <- matrix(m, ncol=3, byrow=TRUE)
norm_cum_currSM1rcls <- reclassify(norm_cum_currSM1, rclmat)
writeRaster(norm_cum_currSM1rcls, filename=file.path(spatialOutDir,'norm_cum_currSM1rcls'), format="GTiff", overwrite=TRUE)

hist(norm_cum_curr,
     main = "Distribution of normalized_cum_currmap values",
     xlab = "Value", ylab = "Frequency",
     col = "green")

freq(norm_cum_curr)
freq(normalized_cum_currmap)

#normalize (normalized_cum_currmap)


