# Pipeline Setup

1) Add aws credentials to the library group as an environmental group
3) Create a GitHub repository and push your code.
4) create a pipeline on azure DevOps that use "azure-pipeline.yaml" file 
5) Allow access to the pipeline to these secrets
6) once you push your code to the master branch the pipeline will trigger and apply the pipeline 
7) This pipeline will run on container agent with this image "mohamedhani/terraform"
