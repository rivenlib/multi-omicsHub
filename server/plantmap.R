plantmap_server <- function(input, output, session) {

  data <- dat3

  print("go!")
  # 存储筛选结果
  PM_filtered_data3 <- reactiveVal()
  PM_nodes<- reactiveVal()
  PM_edgs<- reactiveVal()
  PM_dgree<-data.frame()
  PM_down<-reactiveVal()
  observeEvent(eventExpr = input$root_go, {

    
    output$ui_platmap <- renderUI({
      
      removeUI(selector = "#default_root")
      #fluidRow( #dataTableOutput("roi"))
      
     
      
      # fluidRow(
      #   
      #   column(width =6,
      #          box(status = "primary", class = "left-box",style="padding:0px;",width = "auto",
      #              plotOutput("heatmapPlot",height = "100%") ),
      #   ),
      #   column(width = 6,
      #          fluidRow(
      #            box( status = "primary", class = "right-box",style="padding:0px;",width  = "auto",
      #                 
      #                 plotOutput("TF_heatmap",height = "100%")
      #                 
      #            ) 
      #          ),
      #          fluidRow(
      #            box( status = "primary", class = "right-box",style="padding:0px;", width = "auto",
      #                 forceNetworkOutput("TFnet",height = "100%")
      #            ) 
      #          )
      #   )
      # )
      fluidRow(
        
        column(width =4,
               box(status = "primary", class = "left-box",style="padding:0px;",width = "auto",
                   plotOutput("heatmapPlot",height = "1000px") ),
        ),
        column(width = 8,
               fluidRow(
                 box( status = "primary", class = "right-box",style="padding:0px;",width  = "auto",
                      plotOutput("TF_heatmap",height = "500px")
                 )
               ),
               fluidRow(
                 box( status = "primary", class = "right-box",style="padding:0px;",width = "auto",
                      forceNetworkOutput("TFnet",height = "500px")
                 )
               )
        )

      )

    })
  })
  
  
  # output$roi <- renderDataTable({
  #   if(is.null(input$SG)||input$SG=="")
  #   {
  # 
  #   }
  #   else
  #   {
  #     data<-df3[grep(input$SG, df3[['targetID']], ignore.case = TRUE),]
  #   }
  # 
  # },options = list(scrollX = TRUE, scrollY = "500px"),#filter = list(input$search)
  # )

  
 output$heatmapPlot <- renderPlot({

   if(is.null(input$SG)||input$SG=="")
   {

   }
   else
   {
     gen_name<-input$SG
    print(gen_name)
     id=colnames(quant.data)[which(names(quant.data) == input$SG)]

     ggPlantmap.heatmap(quant.data,get(id),show.legend = F)+
       scale_fill_gradient2(low="white",mid = "yellow",high="red") +
        labs(title=input$SG) ## Title of the plot should be name of the gene
   }
 })
 
 
 


 output$TFnet <- renderForceNetwork({
   if(is.null(input$SG)||input$SG=="")
   {

   }
   else
   {
     data<-df3[grep(input$SG, df3[['targetID']], ignore.case = TRUE),]


     PM_filtered_data3(data)

     # 提取边,
     PM_edgs(
       data.frame(
         select(PM_filtered_data3(), 'TF_ID', 'targetID')
       )
     )

     #write.table(PM_edgs(),  sep = "\t", quote = F,row.names = FALSE)
     #结点
     PM_nodes(
       data.frame(col1 = c(PM_edgs()$TF_ID, PM_edgs()$targetID), col2 = c(PM_filtered_data3()$TF_Symbol1, PM_filtered_data3()$targetSymbol))%>%
         distinct()
       #{rename(., name = col1, group = col2)}
     )

     #PM_nodes(rename(PM_nodes(), name = col1, group = col2))
     # write.table(PM_nodes(),  sep = "\t", quote = F,row.names = FALSE)
     # 统计每个结点的出度
     PM_dgree <- PM_edgs() %>%
       count(targetID, name = "weight")


     PM_edgs <- PM_edgs() %>%
       mutate(weight = ifelse(targetID %in% PM_dgree$targetID, PM_dgree[match(targetID, PM_dgree$targetID), "weight"], 0))
     PM_down(PM_edgs)


     {


       if(nrow(PM_down()) <1){
         showModal(modalDialog(
           title = "警告",
           HTML("过滤后没有边可显示！"),
           easyClose = TRUE,
           footer = NULL
         ))
       }
       else{

         #PM_edgs <- subset(PM_edgs, weight >= input$threshold)
         #write.table(edgs, sep = "\t", row.names = T)

         #结点
         nodes<-data.frame(col1 = c(PM_edgs$TF_ID, PM_edgs$targetID))%>%#, col2 = c(data$TFname, data$Symbol))%>%
           distinct()
         # %>%
         #     rename(name=col1)#,group=col2)
         #write.table(nodes, sep = "\t", row.names = T)



         # nodes_frame<-as.data.frame(nodes)
         # rownames(nodes_frame) <- seq(0, nrow(nodes_frame) - 1)
         # edgs_frame<-as.data.frame(edgs)
         # rownames(edgs_frame) <- seq(0, nrow(edgs_frame) - 1)
         # write.table( net_d3$node, sep = "\t", row.names = T)
         # write.table( edgs, sep = "\t", row.names = T)





         # Generate graph from data frame
         net_pc <- graph_from_data_frame(
           d=PM_edgs,vertices=nodes,
           directed=FALSE
         )


         # Calculate edge weights based on some criterion (e.g., degree)
         #E(net_pc)$weight<-PM_edgs$weight
         wc <- cluster_walktrap(net_pc)
         members <- membership(wc)
         net_d3  <- igraph_to_networkD3(net_pc,group = members)


         #number of 0 begin
         # edgs_frame<-as.data.frame(net_d3$links)
         # rownames(edgs_frame) <- seq(0, nrow(edgs_frame) - 1)
         # nodes_frame<-as.data.frame(net_d3$nodes)
         # rownames(nodes_frame) <- seq(0, nrow(nodes_frame) - 1)



         #net_d3$links <- subset(net_d3$links, value >= input$threshold)
         write.table( net_d3$node, sep = "\t", row.names = T)
         net_out <- forceNetwork(Links = net_d3$links, Nodes = net_d3$nodes,
                                 Source = 'source', Target = 'target',
                                 NodeID = 'name', Group = 'group',
                                 zoom = F, bounded = F,
                                 opacity = 5, fontSize = 32,
                                 charge = -5
         )
         #output$results3_2 <- renderDataTable({net_d3$links})

         #return(net_out)
         #}
       }
     }
   }
 })
 
 output$TF_heatmap <- renderPlot({
   if(is.null(input$SG)||input$SG=="")
   {

   }
   else
   {
     data<-df3[grep(input$SG, df3[['targetID']], ignore.case = TRUE),]

     # 获取data数据表中"TF_ID"列元素
     TF_ID_values <- unique(data$TF_ID)

     # 创建一个新的数据表，列名由data数据表中的"TF_ID"列元素组成
     new_data <- data.frame(matrix(NA, nrow = nrow(new.express), ncol = length(TF_ID_values)))
     colnames(new_data) <- TF_ID_values

     # 将new.express数据表中的数据复制到新数据表中
     # 初始化一个空的数据框来存储最终结果
     final_data_hist <- data.frame()

     for (i in 1:length(TF_ID_values)) {
       index <- TF_ID_values[i]
       cat(index)
       if (index %in% colnames(new.express)) {
         # 截取列名为index的列
         index_column <- new.express[[index]]

         # 检查数据是否为空
         if (!is.null(index_column) && length(index_column) > 0) {
           # 创建一个新的数据框并将截取的列添加进去
           data_hist <- data.frame(index_column)

           # 设置列名为TF_ID_values[i]
           colnames(data_hist) <- index

           # 将新创建的数据框追加到最终结果数据框中
           if (nrow(final_data_hist) == 0) {
             final_data_hist <- data_hist
           } else {
             final_data_hist <- cbind(final_data_hist, data_hist)
           }

           # 输出成功信息
           cat("列已成功截取并追加到最终结果数据框 final_data_hist 中\n")
         } else {
           cat("列 ", index, " 中没有数据\n")
         }
       } else {
         cat("数据框 express 中不存在名为", index, "的列\n")
       }
     }
     rownames(final_data_hist) <-new.express$ROI.name
   }

   # 右上方区域的绘图代码
   # 调整绘图边距
   pheatmap(final_data_hist)
   #plot(1:10, main = "Upper Right Plot")
 })
 
 

}
