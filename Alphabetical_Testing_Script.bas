Attribute VB_Name = "Module1"
Sub alphabetical_testing()

Dim ws As Worksheet
For Each ws In ThisWorkbook.Sheets
ws.Activate

'Variables
Dim ticker As String
Dim opn As Double
Dim cls As Double
Dim lastcol As Integer
Dim lastrow As Long
Dim i As Long
Dim sumrow As Integer
Dim columnrow As Integer
Dim perchange As Double
Dim yrchange As Double
Dim pup As Double
Dim pdown As Double
Dim bigvol As Double
Dim pupticker As String
Dim pdownticker As String
Dim bigvolticker As String

'Initial assignment of variables
ticker = Cells(2, 1)
opn = Cells(2, 3)
lastcol = Cells(1, Columns.Count).End(xlToLeft).Column
vol = 0
pup = 0
pdown = 0
bigvol = 0
lastrow = Cells(Rows.Count, 1).End(xlUp).Row
columnrow = 2

'Create headers for summary table
Cells(1, lastcol + 3).Value = "Ticker"
Cells(1, lastcol + 4).Value = "Yearly Change"
Cells(1, lastcol + 5).Value = "Percent Change"
Cells(1, lastcol + 6).Value = "Total Stock Volume"


For i = 2 To lastrow
   'If statement that will loop through data until it reaches a cell where the next cell is different
   If Cells(i + 1, 1) <> Cells(i, 1) Then
       ticker = Cells(i, 1)
       Cells(columnrow, lastcol + 3) = ticker
       vol = vol + Cells(i, 7)
       Cells(columnrow, lastcol + 6) = vol
       cls = Cells(i, 6)
           'If statement to take care of instances where there is a 0 as a value for open or close
           If opn = cls Then
               perchange = 0
           ElseIf opn = 0 Then
               yrchange = cls
               perchange = 100
           ElseIf cls = 0 Then
               yrchange = opn * -1
               perchange = -100
           Else
               yrchange = cls - opn
               perchange = ((cls - opn) / opn)

                   'If statement to capture largest percent increase and it's associated ticker
                   If perchange > 0 Then
                       If perchange > pup Then
                           pupticker = ticker
                           pup = perchange
                       End If
                   End If

                   'If statement to capture largest percent decrease and it's associated ticker
                    If perchange < 0 Then
                       If perchange < pdown Then
                           pdownticker = ticker
                           pdown = perchange
                       End If
                   End If

               Cells(columnrow, lastcol + 4) = yrchange

                   'Assigning conditional formating
                   If Cells(columnrow, lastcol + 4).Value >= 0 Then
                   Cells(columnrow, lastcol + 4).Interior.ColorIndex = 10
                   Else
                   Cells(columnrow, lastcol + 4).Interior.ColorIndex = 3
                   End If

               Cells(columnrow, lastcol + 5) = perchange
           End If

       opn = Cells(i + 1, 3)
       columnrow = columnrow + 1
           'If statement to capture largest volume and it's associated ticker
           If vol > bigvol Then
               bigvolticker = ticker
               bigvol = vol
           End If
       vol = 0
   Else
       vol = vol + Cells(i, 7)

   End If


Next i

'Setting up the comparison table
Cells(2, lastcol + 8) = "Greatest % Increase"
Cells(3, lastcol + 8) = "Greatest % Decrease"
Cells(4, lastcol + 8) = "Greatest Total Volume"
Cells(1, lastcol + 9) = "Ticker"
Cells(2, lastcol + 9) = pupticker
Cells(3, lastcol + 9) = pdownticker
Cells(4, lastcol + 9) = bigvolticker
Cells(1, lastcol + 10) = "Value"
Cells(2, lastcol + 10) = pup
Cells(3, lastcol + 10) = pdown
Cells(4, lastcol + 10) = bigvol

'Formating cells to number formats and size of cell for viewing
Columns("A:Q").EntireColumn.AutoFit
Columns("L").EntireColumn.NumberFormat = "0.00%"
Columns("K").EntireColumn.NumberFormat = "0.000000000"
Range("Q2").NumberFormat = "0.00%"
Range("Q3").NumberFormat = "0.00%"

Next ws

End Sub

