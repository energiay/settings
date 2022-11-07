
            
    // Создать excel
    var oExcelDoc = new ActiveXObject("Websoft.Office.Excel.Document");
    oExcelDoc.CreateWorkBook();
    var oWorksheet = oExcelDoc.GetWorksheet(0);
    oWorksheet.Cells.GetCell("A1").Value = 50;
    oWorksheet.Cells.GetCell("A2").Value = 80;
    oWorksheet.Cells.GetCell("A3").Value = 20;
    oExcelDoc.SaveAs("путь до excel файла");



    // Запись в excel
    // Стили ячеек: шрифт, цвет, заливка, жирный, наклонный
    var oExcelDoc = new ActiveXObject("Websoft.Office.Excel.Document");
    oExcelDoc.Open("путь до excel файла");
    var oWorksheet = oExcelDoc.GetWorksheet(0);
    var oCellWithBottomBorder;
    for(var i = 1; i < 20; i++) {
        oCell = oWorksheet.Cells.GetCell("A" + i);
        oCell.Value = i;

        // oCell.Style.FontSize = 14;                   // размер шрифта
        // oCell.Style.FontColor = "#cc003d";           // цвет шрифта
        // oCell.Style.ForegroundColor = "#001689";     // заливка ячейки
        // oCell.Style.IsBold = true;                   // жирный
        // oCell.Style.IsItalic = true;                 // курсив
        // oCell.Style.IsTextWrapped = true;            // автоперенос текста
        // oCell.Style.VerticalAlignment =  "Center";   // Выравнивание по вертикали. Принимает значения "Top", "Bottom", "Center".
        // oCell.Style.HorizontalAlignment = "Center";  // Выравнивание по горизонтали. Принимает значения "Left", "Right", "Center", "Justify".
        
        // Устанавливает стиль границ ячейки. 
        // Допустимые значения: "None", "DashDot", "DashDotDot", "Dashed", "Dotted", "Double", "Hair", "Medium", "MediumDashDot", "MediumDashDotDot", "MediumDashed", "SlantedDashDot", "Thick", "Thin".
        // Укажем стиль всем границам ячейки
        oCell.Style.Borders.SetStyle("Thin");
        oCell.Style.Borders.SetColor("#000");
        // нижняя граница ячейки
        // oCellWithBottomBorder = oWorksheet.Cells.GetCell("B7");
        // oBottomBorder = oCellWithBottomBorder.Style.Borders.GetBorder("BottomBorder");
        // oBottomBorder.Color = "#000";
        // oBottomBorder.LineStyle = "Thin";
    }
    oExcelDoc.Save();


    // ширина/высота ячеек
    var oExcelDoc = new ActiveXObject("Websoft.Office.Excel.Document");
    oExcelDoc.Open("путь до excel файла");
    var oWorkSheet = oExcelDoc.GetWorksheet(0);
    if (oWorkSheet != undefined) {
		oExcelDoc.GetWorksheet(0).Cells.SetColumnWidth(1, 100);
        oExcelDoc.GetWorksheet(0).Cells.GetCell("B2").value = 'zhora';
        oExcelDoc.GetWorksheet(0).Cells.Merge(3,3,2,2);

        //oWorkSheet.Cells.SetColumnWidth(1, 100);
        //var oCell = oWorkSheet.Cells.GetCell("B2");
        //oCell.Value = "Zhora"; 

        oExcelDoc.Save();
    }

    var oExcelDoc = new ActiveXObject("Websoft.Office.Excel.Document");
    oExcelDoc.CreateWorkBook();
    var oWorkSheet = oExcelDoc.GetWorksheet(0);
    if (oWorkSheet != undefined) {

        oWorkSheet.Cells.SetRowHeight(1, 100);
        oWorkSheet.Cells.SetColumnWidth(1, 100);

        var oCell = oWorkSheet.Cells.GetCell("B2");
        oCell.Value = "Zhora"; 
    }
    oExcelDoc.SaveAs("путь до excel файла");



// Добавление изображения и текста в ячейк... 
var oExcelDoc = new ActiveXObject("Websoft.Office.Excel.Document");
oExcelDoc.CreateWorkBook();
var oWorkSheet = oExcelDoc.GetWorksheet(0);
var oPic = oWorkSheet.Pictures.AddAbsolute("..\\01.jpg", 1, 1, 40, 40);
oWorkSheet.Cells.SetRowHeight(1, 100);
oWorkSheet.Cells.SetColumnWidth(1, 30);
var oCell = oWorkSheet.Cells.GetCell("B2");
oCell.Style.HorizontalAlignment = "Center";
oCell.Style.VerticalAlignment = "Center";
oCell.Value = "Текст ячейки";        
oExcelDoc.SaveAs("путь до excel файла");
