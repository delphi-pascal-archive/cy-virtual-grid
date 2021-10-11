unit MyComponent;

interface

uses Windows, Graphics, classes, Controls, cyVirtualGrid;

type
  TdgradOrientation = (doVertical, doHorizontal);

  TMyComponent = class(TGraphicControl)
    FcyVirtualGrid: TcyVirtualGrid;
  private
    procedure GradFill(aRect: TRect; fromColor, toColor: TColor; adgradOrientation: TdgradOrientation);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

implementation

{ TMyComponent }

constructor TMyComponent.Create(AOwner: TComponent);
begin
  inherited;
  FcyVirtualGrid := TcyVirtualGrid.Create(self);
  Width := 200;
  Height := 200;
  FcyVirtualGrid.ToCoordX := 9;
  FcyVirtualGrid.ToCoordY := 9;
  FcyVirtualGrid.CellHeightMode := smAutoStretched;
  FcyVirtualGrid.CellWidthMode := smAutoStretched;
  FcyVirtualGrid.GenerateCells(BoundsRect);
end;

destructor TMyComponent.Destroy;
begin
  FcyVirtualGrid.Free;
  inherited;
end;

procedure TMyComponent.Paint;
var
  x, y: Integer;
  aRect: TRect;
begin
  if FcyVirtualGrid.ValidCells  // Allow to know if GenerateCells was called ...
  then
    for x := FcyVirtualGrid.FromCoordX to FcyVirtualGrid.ToCoordX do
      for y := FcyVirtualGrid.FromCoordY to FcyVirtualGrid.ToCoordY do
      begin
        aRect := FcyVirtualGrid.GetCellRect(x, y);
        GradFill(aRect, clWhite, clFuchsia, doVertical);
        Canvas.FrameRect(aRect);
      end;
end;

procedure TMyComponent.GradFill(aRect: TRect; fromColor, toColor: TColor; adgradOrientation: TdgradOrientation);
var
  aBand : TRect;    // Bande rectangulaire de couleur courante
  i, nbDgrad   : integer;  // Compteur pour parcourir la hauteur de la fiche
  Arr_StartRGB : Array[0..2] of Byte;     // RGB de la couleur de départ
  Arr_DifRGB   : Array[0..2] of integer;  // RGB à ajouter à la couleur de départ pour atteindre la couleur de fin
  Arr_CurRGB   : Array[0..2] of Byte;     // RGB de la couleur courante
begin
  // Calcul des valeurs RGB pour la couleur courante
  Arr_StartRGB[0] := GetRValue( ColorToRGB( fromColor ) );
  Arr_StartRGB[1] := GetGValue( ColorToRGB( fromColor ) );
  Arr_StartRGB[2] := GetBValue( ColorToRGB( fromColor ) );

  // Calcul des valeurs à ajouter pour atteindre la couleur de fin
  Arr_DifRGB[0] := GetRValue( ColorToRGB( toColor )) - Arr_StartRGB[0] ;
  Arr_DifRGB[1] := GetgValue( ColorToRGB( toColor )) - Arr_StartRGB[1] ;
  Arr_DifRGB[2] := GetbValue( ColorToRGB( toColor )) - Arr_StartRGB[2] ;

  With Canvas do
  begin
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Pen.Width := 1;
    nbDgrad   := 255;

    if adgradOrientation = doVertical
    then begin
      if aRect.Bottom - aRect.Top < 255
      then nbDgrad := aRect.Bottom - aRect.Top;
    end
    else begin
      if aRect.Right - aRect.Left < 255
      then nbDgrad := aRect.Right - aRect.Left;
    end;

    for i:= 0 to nbDgrad do       // Degradé de um max. de 255 cores ...
    begin
      If adgradOrientation = doVertical
      Then begin
        aBand.Left   := aRect.Left;
        aBand.Right  := aRect.Right;
        aBand.Top    := aRect.Top + MulDiv(i, aRect.Bottom - aRect.Top, nbDgrad+1 );
        aBand.Bottom := aRect.Top + MulDiv( i+1 , aRect.Bottom - aRect.Top, nbDgrad+1 );
      End
      Else begin
        aBand.left   := aRect.Left + MulDiv( i , aRect.Right - aRect.Left, nbDgrad+1 );
        aBand.right  := aRect.Left + MulDiv( i+1 , aRect.Right - aRect.Left, nbDgrad+1 );
        aBand.Top    := aRect.Top;
        aBand.Bottom := aRect.Bottom;
      End;

      // Calcul de la couleur courante
      Arr_CurRGB[0] := (Arr_StartRGB[0] + MulDiv( i, Arr_DifRGB[0] , nbDgrad ));
      Arr_CurRGB[1] := (Arr_StartRGB[1] + MulDiv( i, Arr_DifRGB[1] , nbDgrad ));
      Arr_CurRGB[2] := (Arr_StartRGB[2] + MulDiv( i, Arr_DifRGB[2] , nbDgrad ));

      Brush.color:=RGB(Arr_CurRGB[0], Arr_CurRGB[1], Arr_CurRGB[2]);
      FillRect(aBand);
    end;
  end;
end;

end.
