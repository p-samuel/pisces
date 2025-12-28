unit View.EditNotes;

interface

uses
  System.SysUtils,
  Pisces,
  Model.TripPlanner;

type

  [ TextView('lblNotesList'),
    Text('Notes:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblNotesList = class(TPisces)
  end;

  [ TextView('txtNotesList'),
    Text('(no notes)'),
    TextSize(12),
    TextColor(66, 66, 66),
    Padding(16, 4, 16, 8),
    Height(200)
  ] TTxtNotesList = class(TPisces)
  end;

  [ TextView('lblNewNote'),
    Text('Add New Note:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblNewNote = class(TPisces)
  end;

  [ Edit('edtNewNote'),
    Hint('Enter a note'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtNewNote = class(TPisces)
  end;

  [ Button('btnAddNote'),
    Text('Add Note'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(165, 128, 254),
    Height(TLayout.WRAP),
    Width(TLayout.MATCH),
    Padding(16, 12, 16, 12)
  ] TBtnAddNote = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnClearNotes'),
    Text('Clear All'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(165, 128, 254),
    Height(TLayout.WRAP),
    Width(TLayout.MATCH),
    Padding(16, 12, 16, 12)
  ] TBtnClearNotes = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('editNotesDialog'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(255, 255, 255),
    Padding(90, 90, 90, 90),
    Height(600)
  ] TEditNotesView = class(TPisces)
    FLblNotesList: TLblNotesList;
    FTxtNotesList: TTxtNotesList;
    FLblNewNote: TLblNewNote;
    FEdtNewNote: TEdtNewNote;
    FBtnAddNote: TBtnAddNote;
    FBtnClearNotes: TBtnClearNotes;
    procedure OnViewAttachedToWindowHandler(AView: JView); override;
    procedure RefreshNotesList;
  end;

implementation

uses
  Androidapi.Helpers;

{ TEditNotesView }

procedure TEditNotesView.OnViewAttachedToWindowHandler(AView: JView);
var
  EdtNew: JEditText;
begin
  EdtNew := JEditText(FEdtNewNote.AndroidView);
  EdtNew.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);
  RefreshNotesList;
end;

procedure TEditNotesView.RefreshNotesList;
var
  I: Integer;
  NotesText: String;
  TxtNotes: JTextView;
  Trip: TTripPlan;
begin
  Trip := AppState.GetActiveTrip;
  if Trip = nil then Exit;

  if Length(Trip.Notes) = 0 then
    NotesText := '(no notes)'
  else begin
    NotesText := '';
    for I := 0 to Length(Trip.Notes) - 1 do begin
      if I > 0 then NotesText := NotesText + #13#10;
      NotesText := NotesText + IntToStr(I + 1) + '. ' + Trip.Notes[I];
    end;
  end;

  TxtNotes := JTextView(FTxtNotesList.AndroidView);
  TxtNotes.setText(StrToJCharSequence(NotesText));
end;

{ TBtnAddNote }

procedure TBtnAddNote.OnClickHandler(AView: JView);
var
  ParentView: TEditNotesView;
  EdtNew: JEditText;
  NewNote: String;
  Notes: TArray<String>;
  Trip: TTripPlan;
begin
  Trip := AppState.GetActiveTrip;
  if Trip = nil then Exit;

  ParentView := TEditNotesView(Parent);
  EdtNew := JEditText(ParentView.FEdtNewNote.AndroidView);
  NewNote := Trim(JCharSequenceToStr(EdtNew.getText));

  if NewNote = '' then begin
    TPscUtils.Toast('Enter a note first', 0);
    Exit;
  end;

  Notes := Trip.Notes;
  SetLength(Notes, Length(Notes) + 1);
  Notes[High(Notes)] := NewNote;
  Trip.Notes := Notes;

  EdtNew.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);
  ParentView.RefreshNotesList;
  TPscUtils.Toast('Note added', 0);
end;

{ TBtnClearNotes }

procedure TBtnClearNotes.OnClickHandler(AView: JView);
var
  ParentView: TEditNotesView;
  Trip: TTripPlan;
begin
  Trip := AppState.GetActiveTrip;
  if Trip = nil then Exit;

  ParentView := TEditNotesView(Parent);
  Trip.Notes := [];
  ParentView.RefreshNotesList;
  TPscUtils.Toast('Notes cleared', 0);
end;

end.
