# FilePicker

File picker and media utilities for Android. 

```delphi
uses
  Pisces;
```

## Picking Files

All pick methods return `Jnet_Uri`:

```delphi
// Pick image
TPscUtils.Picker.PickImage(
  procedure(Uri: Jnet_Uri)
  begin
    Bitmap := TPscUtils.LoadBitmap(Uri);
  end
);

// Pick video
TPscUtils.Picker.PickVideo(
  procedure(Uri: Jnet_Uri)
  begin
    // Use Uri
  end
);

// Pick audio
TPscUtils.Picker.PickAudio(
  procedure(Uri: Jnet_Uri)
  begin
    // Use Uri
  end
);

// Pick document
TPscUtils.Picker.PickDocument(
  procedure(Uri: Jnet_Uri)
  begin
    // Use Uri
  end
);

// Pick any file type
TPscUtils.Picker.PickFile('application/pdf',
  procedure(Uri: Jnet_Uri)
  begin
    // Use Uri
  end
);
```

## Picking as Stream

Get raw bytes directly:

```delphi
TPscUtils.Picker.PickImageAsStream(
  procedure(Stream: TMemoryStream)
  begin
    // Use stream
    Stream.Free;
  end
);

TPscUtils.Picker.PickVideoAsStream(...);
TPscUtils.Picker.PickAudioAsStream(...);
TPscUtils.Picker.PickDocumentAsStream(...);
TPscUtils.Picker.PickFileAsStream(MimeType, ...);
```

## Media Actions

Camera and sharing via `TPscUtils.Media`:

```delphi
// Take photo - returns Uri
TPscUtils.Media.TakePhoto(
  procedure(Uri: Jnet_Uri)
  begin
    Bitmap := TPscUtils.LoadBitmap(Uri);
  end
);

// Take video - returns Uri
TPscUtils.Media.TakeVideo(
  procedure(Uri: Jnet_Uri)
  begin
    // Video at Uri
  end
);

// Share text
TPscUtils.Media.ShareText('Hello!', 'Share via');

// Share image
TPscUtils.Media.ShareImage(ImageUri, 'Share');

// Share file
TPscUtils.Media.ShareFile(FileUri, 'application/pdf', 'Share');
```

## Loaders

Convert Uri to data:

```delphi
// Load bitmap from Uri
Bitmap := TPscUtils.LoadBitmap(Uri);

// Load stream from Uri
Stream := TPscUtils.LoadStream(Uri);

// Or use picker converters directly
Bitmap := TPscUtils.Picker.UriToBitmap(Uri);
Stream := TPscUtils.Picker.UriToStream(Uri);
```
