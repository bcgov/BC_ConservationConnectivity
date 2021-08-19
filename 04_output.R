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

file.path(ConnDir,RunDir)

normalized_cum_currmap <- raster(file.path(ConnDir,RunDir,'normalized_cum_currmap.tif'))
cum_currmap <- raster(file.path(ConnDir,RunDir,'cum_currmap.tif'))
flow_potential <- raster(file.path(ConnDir,RunDir,'flow_potential.tif'))

plot(normalized_cum_currmap)
plot(cum_currmap)
plot(flow_potential)

cellStats(flow_potential,range)

