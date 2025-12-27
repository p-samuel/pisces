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
  end;

var
  CurrentNotesTrip: TTripPlan;
  CurrentNotesView: TEditNotesView;

procedure PopulateEditNotesForm(View: TEditNotesView; Trip: TTripPlan);
procedure RefreshNotesList;

implementation

uses
  Androidapi.Helpers;

procedure RefreshNotesList;
var
  I: Integer;
  NotesText: String;
  TxtNotes: JTextView;
begin
  if (CurrentNotesTrip = nil) or (CurrentNotesView = nil) then Exit;

  if Length(CurrentNotesTrip.Notes) = 0 then
    NotesText := '(no notes)'
  else begin
    NotesText := '';
    for I := 0 to Length(CurrentNotesTrip.Notes) - 1 do begin
      if I > 0 then NotesText := NotesText + #13#10;
      NotesText := NotesText + IntToStr(I + 1) + '. ' + CurrentNotesTrip.Notes[I];
    end;
  end;

  TxtNotes := JTextView(CurrentNotesView.FTxtNotesList.AndroidView);
  TxtNotes.setText(StrToJCharSequence(NotesText));
end;

procedure PopulateEditNotesForm(View: TEditNotesView; Trip: TTripPlan);
var
  EdtNew: JEditText;
begin
  CurrentNotesTrip := Trip;
  CurrentNotesView := View;

  EdtNew := JEditText(View.FEdtNewNote.AndroidView);
  EdtNew.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);

  RefreshNotesList;
end;

{ TBtnAddNote }

procedure TBtnAddNote.OnClickHandler(AView: JView);
var
  EdtNew: JEditText;
  NewNote: String;
  Notes: TArray<String>;
begin
  if CurrentNotesTrip = nil then Exit;

  EdtNew := JEditText(CurrentNotesView.FEdtNewNote.AndroidView);
  NewNote := Trim(JCharSequenceToStr(EdtNew.getText));

  if NewNote = '' then begin
    TPscUtils.Toast('Enter a note first', 0);
    Exit;
  end;

  Notes := CurrentNotesTrip.Notes;
  SetLength(Notes, Length(Notes) + 1);
  Notes[High(Notes)] := NewNote;
  CurrentNotesTrip.Notes := Notes;

  EdtNew.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);
  RefreshNotesList;
  TPscUtils.Toast('Note added', 0);
end;

{ TBtnClearNotes }

procedure TBtnClearNotes.OnClickHandler(AView: JView);
begin
  if CurrentNotesTrip = nil then Exit;

  CurrentNotesTrip.Notes := [];
  RefreshNotesList;
  TPscUtils.Toast('Notes cleared', 0);
end;

end.
