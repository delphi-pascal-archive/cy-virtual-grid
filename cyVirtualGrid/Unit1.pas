unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, cyVirtualGrid, StdCtrls, Spin, Buttons;

type
  TCellType = (ctBlank, ctBlack, ctWhite);

  CellGame = Record
    CellType: TCellType;
  end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PaintConcept: TPaintBox;
    cyVGridConcept: TcyVirtualGrid;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Label1: TLabel;
    SERows: TSpinEdit;
    Label2: TLabel;
    SEColumns: TSpinEdit;
    GroupBox1: TGroupBox;
    RBColAutoFixed: TRadioButton;
    RBColAutoStretched: TRadioButton;
    RBColManual: TRadioButton;
    SEColWidth: TSpinEdit;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    RBRowAutoFixed: TRadioButton;
    RBRowAutoStretched: TRadioButton;
    RBRowManual: TRadioButton;
    SERowHeight: TSpinEdit;
    BtnApplyConcept: TBitBtn;
    cyVGridEvents: TcyVirtualGrid;
    Panel2: TPanel;
    Label3: TLabel;
    SERow0: TSpinEdit;
    Label6: TLabel;
    SERow1: TSpinEdit;
    Label7: TLabel;
    SERow2: TSpinEdit;
    Label8: TLabel;
    SERow3: TSpinEdit;
    Label9: TLabel;
    SERow4: TSpinEdit;
    Label10: TLabel;
    Label11: TLabel;
    SECol0: TSpinEdit;
    Label12: TLabel;
    SECol1: TSpinEdit;
    Label13: TLabel;
    SECol2: TSpinEdit;
    Label14: TLabel;
    SECol3: TSpinEdit;
    Label15: TLabel;
    SECol4: TSpinEdit;
    Label16: TLabel;
    PaintEvents: TPaintBox;
    BtnApplyEvents: TBitBtn;
    TabSheet3: TTabSheet;
    cyVGridGames: TcyVirtualGrid;
    Panel3: TPanel;
    BtnNewGame: TBitBtn;
    PaintGames: TPaintBox;
    TabSheetCompo: TTabSheet;
    Panel4: TPanel;
    BtnCreateComponent: TBitBtn;
    Label17: TLabel;
    procedure PaintConceptPaint(Sender: TObject);
    procedure BtnApplyConceptClick(Sender: TObject);
    procedure BtnApplyEventsClick(Sender: TObject);
    procedure cyVGridEventsColumnSize(Sender: TObject; CoordX: Integer;
      var Size: Word);
    procedure cyVGridEventsRowSize(Sender: TObject; CoordY: Integer;
      var Size: Word);
    procedure cyVGridEventsGeneratedCell(Sender: TObject; Rect: TRect;
      CoordX, CoordY: Integer);
    procedure PaintEventsPaint(Sender: TObject);
    procedure PaintConceptMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BtnNewGameClick(Sender: TObject);
    procedure PaintGamesPaint(Sender: TObject);
    procedure BtnCreateComponentClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  ArrayCellsGame: Array of Array of CellGame;

implementation

uses MyComponent;

{$R *.dfm}

// ***************************************** //
// ************** The Concept ************** //
// ***************************************** //
procedure TForm1.BtnApplyConceptClick(Sender: TObject);
begin
  // Columns definition :
  cyVGridConcept.ToCoordX := SEColumns.Value-1;

  if RBColAutoFixed.Checked
  then
    cyVGridConcept.CellWidthMode := smAutoFixed
  else
    if RBColAutoStretched.Checked
  then
    cyVGridConcept.CellWidthMode := smAutoStretched
  else begin
    cyVGridConcept.CellWidthMode := smManual;
    cyVGridConcept.CellWidth := SEColWidth.Value;
  end;


  // Rows definition :
  cyVGridConcept.ToCoordY := SERows.Value-1;

  if RBRowAutoFixed.Checked
  then
    cyVGridConcept.CellHeightMode := smAutoFixed
  else
    if RBRowAutoStretched.Checked
  then
    cyVGridConcept.CellHeightMode := smAutoStretched
  else begin
    cyVGridConcept.CellHeightMode := smManual;
    cyVGridConcept.CellHeight := SERowHeight.Value;
  end;

  cyVGridConcept.GenerateCells(PaintConcept.ClientRect);  // Region ...
  PaintConcept.Refresh;
end;

procedure TForm1.PaintConceptPaint(Sender: TObject);
var
  x, y: Integer;
  aRect: TRect;
begin
  PaintConcept.Canvas.Brush.Color := clBlack;
  PaintConcept.Canvas.Rectangle(PaintConcept.ClientRect);

  if cyVGridConcept.ValidCells  // Allow to know if GenerateCells was called ...
  then
    for x := cyVGridConcept.FromCoordX to cyVGridConcept.ToCoordX do
      for y := cyVGridConcept.FromCoordY to cyVGridConcept.ToCoordY do
      begin
        PaintConcept.Canvas.Brush.Color := clGreen;

        aRect := cyVGridConcept.GetCellRect(x, y);
        PaintConcept.Canvas.Rectangle(aRect);
      end;
end;

procedure TForm1.PaintConceptMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  aRect: TRect;
  CoordX, CoordY: Integer;
begin
  if cyVGridConcept.ValidCells
  then begin
    PaintConcept.Canvas.Brush.Color := clLime;

    if cyVGridConcept.GetCellCoord(X, Y, CoordX, CoordY)
    then begin
      aRect := cyVGridConcept.GetCellRect(CoordX, CoordY);
      PaintConcept.Canvas.Rectangle(aRect);
    end;
  end;
end;

// ***************************************** //
// ************** Using Events ************* //
// ***************************************** //

procedure TForm1.BtnApplyEventsClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  PaintEvents.Canvas.Brush.Color := clBlack;
  PaintEvents.Canvas.Rectangle(PaintEvents.ClientRect);
  cyVGridEvents.GenerateCells(PaintEvents.ClientRect);  // Region ...
//  PaintEvents.Refresh;
  Screen.Cursor := crDefault;
end;

procedure TForm1.cyVGridEventsColumnSize(Sender: TObject; CoordX: Integer;
  var Size: Word);
begin
  if CoordX < 5
  then Size := TSpinEdit( FindComponent('SECol' + intToStr(CoordX)) ).Value;
end;

procedure TForm1.cyVGridEventsRowSize(Sender: TObject; CoordY: Integer;
  var Size: Word);
begin
  if CoordY < 5
  then Size := TSpinEdit( FindComponent('SERow' + intToStr(CoordY)) ).Value;
end;

procedure TForm1.cyVGridEventsGeneratedCell(Sender: TObject; Rect: TRect;
  CoordX, CoordY: Integer);
var aRect: TRect;
begin
  aRect := cyVGridEvents.GetCellRect(CoordX, CoordY);
  PaintEvents.Canvas.Brush.Color := clLime;
  PaintEvents.Canvas.Rectangle(aRect);
  Sleep(30);
  PaintEvents.Canvas.Brush.Color := clGreen;
  PaintEvents.Canvas.Rectangle(aRect);
end;

procedure TForm1.PaintEventsPaint(Sender: TObject);
var
  x, y: Integer;
  aRect: TRect;
begin
  PaintEvents.Canvas.Brush.Color := clBlack;
  PaintEvents.Canvas.Rectangle(PaintEvents.ClientRect);

  if cyVGridEvents.ValidCells  // Allow to know if GenerateCells was called ...
  then
    for x := cyVGridEvents.FromCoordX to cyVGridEvents.ToCoordX do
      for y := cyVGridEvents.FromCoordY to cyVGridEvents.ToCoordY do
      begin
        PaintEvents.Canvas.Brush.Color := clGreen;

        aRect := cyVGridEvents.GetCellRect(x, y);
        PaintEvents.Canvas.Rectangle(aRect);
      end;
end;

// ***************************************** //
// *************** For Games *************** //
// ***************************************** //
procedure TForm1.BtnNewGameClick(Sender: TObject);
var x, y: Integer;
begin
  // Prepare new game :
  Setlength(ArrayCellsGame, cyVGridGames.ToCoordX+1, cyVGridGames.ToCoordY+1);

  for x := 0 to cyVGridGames.ToCoordX do
    for y := 0 to cyVGridGames.ToCoordY do
      ArrayCellsGame[x, y].CellType := ctBlank;

  // Black player :
  // Line 1 :
  ArrayCellsGame[0, 0].CellType := ctBlack;
  ArrayCellsGame[2, 0].CellType := ctBlack;
  ArrayCellsGame[4, 0].CellType := ctBlack;
  ArrayCellsGame[6, 0].CellType := ctBlack;
  ArrayCellsGame[8, 0].CellType := ctBlack;

  // Line 2 :
  ArrayCellsGame[1, 1].CellType := ctBlack;
  ArrayCellsGame[3, 1].CellType := ctBlack;
  ArrayCellsGame[5, 1].CellType := ctBlack;
  ArrayCellsGame[7, 1].CellType := ctBlack;
  ArrayCellsGame[9, 1].CellType := ctBlack;

  // White player :
  // Line 1 :
  ArrayCellsGame[1, 9].CellType := ctWhite;
  ArrayCellsGame[3, 9].CellType := ctWhite;
  ArrayCellsGame[5, 9].CellType := ctWhite;
  ArrayCellsGame[7, 9].CellType := ctWhite;
  ArrayCellsGame[9, 9].CellType := ctWhite;

  // Line 2 :
  ArrayCellsGame[0, 8].CellType := ctWhite;
  ArrayCellsGame[2, 8].CellType := ctWhite;
  ArrayCellsGame[4, 8].CellType := ctWhite;
  ArrayCellsGame[6, 8].CellType := ctWhite;
  ArrayCellsGame[8, 8].CellType := ctWhite;

  cyVGridGames.GenerateCells(classes.Rect(10, 10, 600, 600));  // Region ...
  PaintGames.Refresh;
end;

procedure TForm1.PaintGamesPaint(Sender: TObject);
var
  x, y: Integer;
  aRect: TRect;

      procedure DRAW_OBJECT(PenColor: TColor; BrushColor: TColor; CellRect: TRect);
      begin
        InflateRect(CellRect, -2, -2);
        PaintGames.Canvas.Pen.Color := PenColor;
        PaintGames.Canvas.Brush.Color := BrushColor;
        PaintGames.Canvas.Ellipse(CellRect);
      end;

begin
  PaintGames.Canvas.Pen.Color := clGray;
  PaintGames.Canvas.Brush.Color := clNavy;
  PaintGames.Canvas.Rectangle(PaintGames.ClientRect);

  if cyVGridGames.ValidCells  // Allow to know if GenerateCells was called ...
  then
    for x := cyVGridGames.FromCoordX to cyVGridGames.ToCoordX do
      for y := cyVGridGames.FromCoordY to cyVGridGames.ToCoordY do
      begin
        // Draw cell table game :
        if x mod 2 = 0
        then begin
          if y mod 2 = 0
          then PaintGames.Canvas.Brush.Color := $00383838  // Black color
          else PaintGames.Canvas.Brush.Color := $00CFF1EB; // Cream color
        end
        else begin
          if y mod 2 = 0
          then PaintGames.Canvas.Brush.Color := $00CFF1EB  // Cream color
          else PaintGames.Canvas.Brush.Color := $00383838; // Black color
        end;

        aRect := cyVGridGames.GetCellRect(x, y);
        PaintGames.Canvas.Rectangle(aRect);

        // Draw cell object :
        case ArrayCellsGame[x, y].CellType of
          ctBlack: DRAW_OBJECT(clSilver, clBlack, aRect);
          ctWhite: DRAW_OBJECT(clSilver, clWhite, aRect);
        end;
      end;
end;

// ***************************************** //
// ********** Building Components ********** //
// ***************************************** //

procedure TForm1.BtnCreateComponentClick(Sender: TObject);
var Compo: TMyComponent;
begin
  BtnCreateComponent.Enabled := false;
  Compo := TMyComponent.Create(Form1);
  Compo.Parent := TabSheetCompo;
  Compo.Left := 20;
  Compo.Top := 50;
end;

end.
