library(rMVP)
library(shiny)
Args <- commandArgs(trailingOnly = TRUE)

print(Args[1])
print(Args[2])

src=Args[1]
outpath=Args[2]


    
genotype <- attach.big.matrix("/z50/pangbingwen/multi-omicsHub/extdata/HDRA-G6-4-RDP1-RDP2-NIAS/mvp.vcf.geno.desc")

phenotype <- read.table(src,head=TRUE)
map <- read.table("/z50/pangbingwen/multi-omicsHub/extdata/HDRA-G6-4-RDP1-RDP2-NIAS/mvp.vcf.geno.map" , head = TRUE)
#Kinship <- attach.big.matrix("/z50/pangbingwen/multi-omicsHub/extdata/HDRA-G6-4-RDP1-RDP2-NIAS/mvp.vcf.kin.desc")
#Covariates_PC <- bigmemory::as.matrix(attach.big.matrix("/z50/pangbingwen/multi-omicsHub/extdata/HDRA-G6-4-RDP1-RDP2-NIAS/mvp.vcf.pc.desc"))


  imMVP <- MVP(
    phe=phenotype,
    geno=genotype,
    map=map,
    #K=Kinship,
    #CV.GLM=Covariates_PC,
    #CV.MLM=Covariates_PC,
    #CV.FarmCPU=Covariates_PC,
    nPC.GLM=3,
    nPC.MLM=3,
    nPC.FarmCPU=3,
    priority="speed",
    ncpus=30,
    vc.method="BRENT",
    maxLoop=1,
    method.bin="static",
    permutation.threshold=TRUE,
    permutation.rep=100,
    threshold=0.05,
    method=c("GLM", "MLM", "FarmCPU"),
    outpath=outpath,
    file.output=TRUE,
    file.type = "jpg", dpi = 300,
  )
pwd<-paste(outpath,"/..")
folders <- list.dirs(pwd, full.names = FALSE)
      updateSelectizeInput(
	session,
        inputId = "folder_select",
        choices = folders,
        server = TRUE
      )
#MVP.Data(fileBed="rice_3",
#         filePhe="pmvp.plink.phe",
#         fileKin="mvp.plink.kin.txt",
#         filePC="mvp.plink,pc.txt",       
#         #priority="speed",
#         #maxLine=10000,
#         out="mvp.plink"
#         )
