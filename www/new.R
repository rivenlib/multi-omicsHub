new.ggPlantmap <- XML.to.ggPlantmap("../plantMap/roi.xml")
print(new.ggPlantmap)
new.express<-read.table("../plantMap/roi.txt",head=T)
print(new.express)
ggPlantmap.merge(new.ggPlantmap,new.express,"ROI.name")
quant.data=ggPlantmap.merge(new.ggPlantmap,new.express,"ROI.name")
print(quant.data)
id=colnames(quant.data)[which(names(quant.data) == "Os03g0103100")]
print(id)

ggPlantmap.heatmap(quant.data,get(id))
