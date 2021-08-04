
#use double quotes
#input directory /Users/darkbabine/biodiveristy/omni
#writes to ...
#sudo ln -s /Applications/Julia-1.6.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia

#Resistence and Sourcec rasters
layer <- raster('/Users/darkbabine/ProjectLibrary/omni/test/input/resistance.asc')
sites <- raster('/Users/darkbabine/ProjectLibrary/omni/test/input/source.asc')
#Reclassify as required

#Build Omniscape file and target directory #Needs to be simple directory name - no spaces or brackets

RunDir<-"Test5"
#dir.create(file.path(ConnDir,RunDir),showWarnings=FALSE) # Ominscape will create
#write Omniscape input raster to directory
#writeRaster(sites,file.path(OmniDir,RunDir,"sites_rast.asc"),overwrite=TRUE)
#writeRaster(layer,file.path(OmniDir,RunDir,"resis_rast.asc"),overwrite=TRUE)

writeRaster(sites,file.path(ConnDir,"sites_rast.asc"),overwrite=TRUE)
writeRaster(layer,file.path(ConnDir,"resis_rast.asc"),overwrite=TRUE)

#Build ini file for omniscape
OS_ini<-c(paste("resistance_file = ",file.path(ConnDir,"resis_rast.asc")),
          paste("source_file = ", file.path(ConnDir,"sites_rast.asc")),
"[Options]",
"block_size = 3",
"radius = 5",
"buffer = 2",
"source_threshold = 0.2",
paste("project_name = ",file.path(ConnDir,RunDir),sep=''),
"calc_flow_potential = true",
"correct_artifacts = true",
"source_from_resistance = false",
"r_cutoff = 0.0",
"write_raw_currmap = true",
"calc_normalized_current = true",
"write_as_tif = true",
"parallelize = true")

#configLocation<-file.path(OmniDir,"Test1/config.ini")
configLocation<-file.path(ConnDir,"config.ini")
cat(OS_ini, sep="\n", file=configLocation)

script <- c('using Omniscape',  
            paste('run_omniscape(',configLocation,')',sep='"'))
cat(script, sep="\n", file="script.jl")
#cat(script, sep="\n", file=file.path(ConnDir,"script.jl"))

Julia_exe <- ('julia script.jl')
#Julia_exe <- (file.path('julia ',ConnDir,'script.jl'))
system(Julia_exe)


rdist <- as.dist(read.csv("Omni/CS_resistances.out",sep=" ",row.names=1,header=1))
return(rdist)







#doesnt like spaces or "(" in file names - write to simpler directory
#figure out how to fire up Julia from R then launch code
run_omniscape("/Users/darkbabine/ProjectLibrary/omni/test/config.ini")

OmniDir <- file.path('/Users/darkbabine/ProjectLibrary/omni/test')
Julia_exe <- 'julia include("script_path.jl")' 
system(Julia_exe)

Julia_exe <- ('julia script.jl')
system(Julia_exe)

julia 

script.jl
using Omniscape
run_omniscape("/Users/darkbabine/ProjectLibrary/omni/test/config.ini")



system(CS_exe)

CS_run <- paste(CS_exe, paste(getwd(),"myini.ini",sep="/"))

#Build ini file from R
#File needs to look like this:
[Input files]
resistance_file = /Users/darkbabine/ProjectLibrary/omni/test/input/resistance.asc
source_file = /Users/darkbabine/ProjectLibrary/omni/test/input/source.asc

[Options]
block_size = 2
radius = 5
buffer = 2
source_threshold = 0.2
project_name = test1
calc_flow_potential = true
correct_artifacts = true
source_from_resistance = false
mask_nodata = true

write_raw_currmap = true
calc_normalized_current = true

parallelize = true
parallel_batch_size = 10

solver = wrong_solver_name
###############
runCS <- function(layer, sites){
  require(raster)
  cls <- cellFromXY(layer, sites)
  if (length(unique(cls)) != length(cls)){
    stop("sites are do not fall within unique cells")
  }
  sites <- rasterize(x = sites,y = layer)
  
  
  dir.create("CS",showWarnings=FALSE)
  writeRaster(sites,"CS/sites_rast.asc",overwrite=TRUE)
  writeRaster(layer,"CS/resis_rast.asc",overwrite=TRUE)
  CS_ini <- c("[circuitscape options]",            
              "data_type = raster",
              "scenario = pairwise",
              paste(c("point_file =",
                      "habitat_file =",
                      "output_file ="),
                    paste(c("CS/sites_rast.asc",
                            "CS/resis_rast.asc",
                            "CS/CS.out"))))
  cat(CS_ini, sep="\n", file="CS/myini.ini")
  CS_run <- paste("csrun.py", paste("CS/myini.ini"), paste("&> /dev/null"))
  system(CS_run)
  rdist <- as.dist(read.csv("CS/CS_resistances.out",sep=" ",row.names=1,header=1))
  return(rdist)
}
