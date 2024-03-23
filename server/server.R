Sys.setlocale(category = "LC_ALL", locale = "en_US.UTF-8")
#Strand file
#Transcription and regulation file
#options(shiny.maxRequestSize=100*1024*1024*1024)
options(shiny.maxRequestSize=100*1024*1024)


 # df2_2 <- read_excel("/z50/pangbingwen/snpDB_v3.bak/extdata/df2_2.xlsx")
 # df2 <- read_excel("/z50/pangbingwen/snpDB_v3.bak/extdata/df2.xlsx")
 # df3 <- read.table("/z50/pangbingwen/snpDB_v3.bak/extdata/smb.txt",header = TRUE,sep = "\t")
 # dat2 <- read_excel("/z50/pangbingwen/snpDB_v3.bak/extdata/df2.xlsx",n_max = 5)
 # dat3 <- read.table("/z50/pangbingwen/snpDB_v3.bak/extdata/smb_head.txt",header = TRUE,sep = "\t")
 
 df2_2 <- read_excel("/z50/pangbingwen/multi-omicsHub/extdata/df2_2.xlsx")
 df2 <- read_excel("/z50/pangbingwen/multi-omicsHub/extdata/df2.xlsx")
 df3 <- read.table("/z50/pangbingwen/multi-omicsHub/extdata/smb.txt",header = TRUE,sep = "\t")
 dat2 <- read_excel("/z50/pangbingwen/multi-omicsHub/extdata/df2.xlsx",n_max = 5)
 dat3 <- read.table("/z50/pangbingwen/multi-omicsHub/extdata/smb_head.txt",header = TRUE,sep = "\t")
 quant.data<- read.table("/z50/pangbingwen/multi-omicsHub/extdata/quant.data",header = TRUE,sep = "\t")
 new.express<-read.table("/z50/pangbingwen/multi-omicsHub/extdata/transposed_roi.txt",head=T)
 #read data  for heatmap
 # new.ggPlantmap <- XML.to.ggPlantmap("./extdata/roi_all.xml")
 # new.express<-read.table("./extdata/transposed_roi.txt",head=T)
 # quant.data=ggPlantmap.merge(new.ggPlantmap,new.express,"ROI.name")

# 定义 server
function(input, output,session) {


  output$default2_1 <- renderTable({dat2})
  output$default2_2 <- renderTable({dat2})
  output$default2_3 <- renderTable({dat2})
  output$default3 <- renderTable({dat3})
  output$default_root<-renderTable({dat3})

  #tab2_1_server
  source("./server/var_Reg.R")
  var_Reg_server(input, output)

  #tab2_2_server
  source("./server/var_Gene.R")
  var_Gene_server(input, output)


  #tab2_3_server
  source("./server/var_ID.R")
  var_ID_server(input, output)

  #tab2_4_server
  source("./server/haplotype.R")
  source("./server/hapNetplot_geneHapR.R")
  source("./server/plot_LDheatmap_geneHapR.R")
  source("./server/LDheatmap_geneHapR.R")
  source("./server/makeImageRect_geneHapR.R")
  source("./server/makeImageText_geneHapR.R")
  source("./server/LDheatmapMapNew_geneHapR.add.R")
  source("./server/LDheatmapLegend_geneHapR.add.R")
  haplotype_server(input, output,session)
  #tab2_5_server
  source("./server/gwas.R")
  gwas_server(input, output)
  #tab3_server
  source('./server/network_graph.R')
  source('./server/bar_chart.R')
  source("./server/TF.R")
  TF_server(input, output,session)
  #tab4server
  source("./server/mvp.R")
  mvp_server(input,output,session)
  source("./server/plantmap.R")
  plantmap_server(input,output,session)
}
