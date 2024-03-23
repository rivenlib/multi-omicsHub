ui<-tabItem(
	tabName="tab5",
	#tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
	tags$head(
	  tags$script(HTML('
      $(document).ready(function(){
        var resizeBoxes = function(){
          var windowHeight = $(window).height();
          var rightHeight = windowHeight / 2;
          var leftHeight = rightHeight * 2;
          
          $(".left-box").css("height", leftHeight);
          $(".right-box").css("height", rightHeight);
        };
        
        resizeBoxes();
        
        $(window).resize(function(){
          resizeBoxes();
        });
      });
    '))
	),
	
	fluidPage(
    fluidRow(
      br(),
      column(width = 3,
             selectizeInput(
               "SltDate",
               "Select Dataset",
               choices = c("Arabidopsis","wheat"),
               selected = "Arabidopsis"
             )),
      column(
        width = 3,
        textInput(
          "SG",
          "Search Gene"
        )
        
      ),
      
      column(width = 3,
             div(actionButton(
               "root_go",
               "ROOT-GO!",
               class = "btn-primary"
             ),class="my-column")
      ),
    ),
    br(),
    fluidRow(
      tableOutput("default_root")
    ),
    fluidRow(
      uiOutput("ui_platmap")
    )
    
	)
)
