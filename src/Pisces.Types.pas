unit Pisces.Types;

interface

uses
  Androidapi.JNI.Widget,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNIBridge,
  Androidapi.JNI.Os,
  Androidapi.JNI.App,
  Androidapi.Helpers,
  System.SysUtils,
  Pisces.JNI.Extensions,
  Pisces.Lifecycle,
  Pisces.App;

type
  // java class widgets types helpers and interfaces
  TJViewGroup_LayoutParams = Androidapi.JNI.GraphicsContentViewText.TJViewGroup_LayoutParams;
  TJInputType = Androidapi.JNI.GraphicsContentViewText.TJInputType;
  TJEditorInfo = Androidapi.JNI.GraphicsContentViewText.TJEditorInfo;
  TJGravity = Androidapi.JNI.GraphicsContentViewText.TJGravity;
  TJLayoutMode = Androidapi.JNI.Widget.TJLinearLayout;
  TJColor = Androidapi.JNI.GraphicsContentViewText.TJColor;
  TJViewGroup = Androidapi.JNI.GraphicsContentViewText.TJViewGroup;
  TJView = Androidapi.JNI.GraphicsContentViewText.TJView;
  TJLineBreaker = Androidapi.JNI.GraphicsContentViewText.TJLineBreaker;
  TJAnimation = Androidapi.JNI.GraphicsContentViewText.TJAnimation;
  TJToast = Androidapi.JNI.Widget.TJToast;
  TJTextView_BufferType = Androidapi.JNI.Widget.TJTextView_BufferType;
  TJTextUtils_TruncateAt = Androidapi.JNI.GraphicsContentViewText.TJTextUtils_TruncateAt;
  TJRelativeLayout = Androidapi.JNI.Widget.TJRelativeLayout;
  TJAbsoluteLayout = Androidapi.JNI.Widget.TJAbsoluteLayout;
  TJLinearLayout = Androidapi.JNI.Widget.TJLinearLayout;
  TJTimePicker = Androidapi.JNI.Widget.TJTimePicker;
  TJScrowView = Androidapi.JNI.Widget.TJScrollView;
  TJHorizontalScrollView = Pisces.JNI.Extensions.TJHorizontalScrollView;
  TJFrameLayout = Androidapi.JNI.Widget.TJFrameLayout;
  TJDatePicker = Androidapi.JNI.Widget.TJDatePicker;
  TJCalendarView = Androidapi.JNI.Widget.TJCalendarView;
  TJAdapter = Androidapi.JNI.Widget.TJAdapter;
  TJArrayAdapter = Pisces.JNI.Extensions.TJArrayAdapter;
  TJAdapterView = Androidapi.JNI.Widget.TJAdapterView;
  TJBaseAdapter = Androidapi.JNI.Widget.TJBaseAdapter;
  TJDataSetObserver = Androidapi.JNI.GraphicsContentViewText.TJDataSetObserver;
  TJListView = Androidapi.JNI.Widget.TJListView;
  TJAbsListView = Androidapi.JNI.Widget.TJAbsListView;
  TJListAdapter = Androidapi.JNI.Widget.TJListAdapter;
  TJTextView = Androidapi.JNI.Widget.TJTextView;
  TJCheckedTextView = Pisces.JNI.Extensions.TJCheckedTextView;
  TJEditText = Androidapi.JNI.Widget.TJEditText;
  TJSwitch = Androidapi.JNI.Widget.TJSwitch;
  TJScroller = Androidapi.JNI.Widget.TJScroller;
  TJImageView =  Androidapi.JNI.Widget.TJImageView;
  TJImageView_ScaleType = Androidapi.JNI.Widget.TJImageView_ScaleType;
  TJView_OnLayoutChangeListener = Androidapi.JNI.GraphicsContentViewText.TJView_OnLayoutChangeListener;
  TJBitmapFactory = Androidapi.JNI.GraphicsContentViewText.TJBitmapFactory;
  TJKeyEvent = Androidapi.JNI.GraphicsContentViewText.TJKeyEvent;

  JView_AccessibilityDelegate = Androidapi.JNI.GraphicsContentViewText.JView_AccessibilityDelegate;
  JAnimation = Androidapi.JNI.GraphicsContentViewText.JAnimation;
  JAutofillId = Androidapi.JNI.GraphicsContentViewText.JAutofillId;
  JDrawable = Androidapi.JNI.GraphicsContentViewText.JDrawable;
  JBlendMode = Androidapi.JNI.GraphicsContentViewText.JBlendMode;
  JColorStateList = Androidapi.JNI.GraphicsContentViewText.JColorStateList;
  JPorterDuff_Mode = Androidapi.JNI.GraphicsContentViewText.JPorterDuff_Mode;
  JRect = Androidapi.JNI.GraphicsContentViewText.JRect;
  JContentCaptureSession = Androidapi.JNI.GraphicsContentViewText.JContentCaptureSession;
  JColorFilter = Androidapi.JNI.GraphicsContentViewText.JColorFilter;
  JBitmap = Androidapi.JNI.GraphicsContentViewText.JBitmap;
  JMenuItem = Androidapi.JNI.GraphicsContentViewText.JMenuItem;
  JTimePicker = Androidapi.JNI.Widget.JTimePicker;
  JViewGroup = Androidapi.JNI.GraphicsContentViewText.JViewGroup;
  JView = Androidapi.JNI.GraphicsContentViewText.JView;
  JLinearLayout = Androidapi.JNI.Widget.JLinearLayout;
  JAbsoluteLayout = Androidapi.JNI.Widget.JAbsoluteLayout;
  JRelativeLayout = Androidapi.JNI.Widget.JRelativeLayout;
  JScrollView = Androidapi.JNI.Widget.JScrollView;
  JHorizontalScrollView = Pisces.JNI.Extensions.JHorizontalScrollView;
  JFrameLayout = Androidapi.JNI.Widget.JFrameLayout;
  JDatePicker = Androidapi.JNI.Widget.JDatePicker;
  JCalendarView = Androidapi.JNI.Widget.JCalendarView;
  JAdapter = Androidapi.JNI.Widget.JAdapter;
  JArrayAdapter = Pisces.JNI.Extensions.JArrayAdapter;
  JAdapterView = Androidapi.JNI.Widget.JAdapterView;
  JBaseAdapter = Androidapi.JNI.Widget.JBaseAdapter;
  JDataSetObserver = Androidapi.JNI.GraphicsContentViewText.JDataSetObserver;
  JListView = Androidapi.JNI.Widget.JListView;
  JAbsListView = Androidapi.JNI.Widget.JAbsListView;
  JContext = Androidapi.JNI.GraphicsContentViewText.JContext;
  JListAdapter = Androidapi.JNI.Widget.JListAdapter;
  JViewGroup_LayoutParams = Androidapi.JNI.GraphicsContentViewText.JViewGroup_LayoutParams;
  JTextView = Androidapi.JNI.Widget.JTextView;
  JCheckedTextView = Pisces.JNI.Extensions.JCheckedTextView;
  JEditText = Androidapi.JNI.Widget.JEditText;
  JSwitch = Androidapi.JNI.Widget.JSwitch;
  JScroller = Androidapi.JNI.Widget.JScroller;
  JImageView_ScaleType = Androidapi.JNI.Widget.JImageView_ScaleType;
  JView_OnLayoutChangeListener = Androidapi.JNI.GraphicsContentViewText.JView_OnLayoutChangeListener;
  JImageView = Androidapi.JNI.Widget.JImageView;
  JBitmapFactory = Androidapi.JNI.GraphicsContentViewText.JBitmapFactory;
  JBitmapFactoryClass = Androidapi.JNI.GraphicsContentViewText.JBitmapFactoryClass;
  JKeyEvent = Androidapi.JNI.GraphicsContentViewText.JKeyEvent;

  //java types
  JObject = Androidapi.JNI.JavaTypes.JObject;
  JObjectClass = Androidapi.JNI.JavaTypes.JObjectClass;
  JInputStream = Androidapi.JNI.JavaTypes.JInputStream;
  JByteArrayInputStream = Androidapi.JNI.JavaTypes.JByteArrayInputStream;
  JOutputStream = Androidapi.JNI.JavaTypes.JOutputStream;
  JByteArrayOutputStream = Androidapi.JNI.JavaTypes.JByteArrayOutputStream;
  JAutoCloseable = Androidapi.JNI.JavaTypes.JAutoCloseable;
  JCloseable = Androidapi.JNI.JavaTypes.JCloseable;
  JFile = Androidapi.JNI.JavaTypes.JFile;
  JFileDescriptor = Androidapi.JNI.JavaTypes.JFileDescriptor;
  JFileFilter = Androidapi.JNI.JavaTypes.JFileFilter;
  JFileInputStream = Androidapi.JNI.JavaTypes.JFileInputStream;
  JFileOutputStream = Androidapi.JNI.JavaTypes.JFileOutputStream;
  JFilenameFilter = Androidapi.JNI.JavaTypes.JFilenameFilter;
  JFilterOutputStream = Androidapi.JNI.JavaTypes.JFilterOutputStream;
  JThrowable = Androidapi.JNI.JavaTypes.JThrowable;
  JException = Androidapi.JNI.JavaTypes.JException;
  JIOException = Androidapi.JNI.JavaTypes.JIOException;
  JPrintStream = Androidapi.JNI.JavaTypes.JPrintStream;
  JWriter = Androidapi.JNI.JavaTypes.JWriter;
  JPrintWriter = Androidapi.JNI.JavaTypes.JPrintWriter;
  JRandomAccessFile = Androidapi.JNI.JavaTypes.JRandomAccessFile;
  JReader = Androidapi.JNI.JavaTypes.JReader;
  JSerializable = Androidapi.JNI.JavaTypes.JSerializable;
  JAbstractStringBuilder = Androidapi.JNI.JavaTypes.JAbstractStringBuilder;
  JAppendable = Androidapi.JNI.JavaTypes.JAppendable;
  JBoolean = Androidapi.JNI.JavaTypes.JBoolean;
  JNumber = Androidapi.JNI.JavaTypes.JNumber;
  JByte = Androidapi.JNI.JavaTypes.JByte;
  JCharSequence = Androidapi.JNI.JavaTypes.JCharSequence;
  Jlang_Class = Androidapi.JNI.JavaTypes.Jlang_Class;
  JClassLoader = Androidapi.JNI.JavaTypes.JClassLoader;
  JCloneable = Androidapi.JNI.JavaTypes.JCloneable;
  JComparable = Androidapi.JNI.JavaTypes.JComparable;
  JDouble = Androidapi.JNI.JavaTypes.JDouble;
  JEnum = Androidapi.JNI.JavaTypes.JEnum;
  JFloat = Androidapi.JNI.JavaTypes.JFloat;
  JRuntimeException = Androidapi.JNI.JavaTypes.JRuntimeException;
  JIllegalArgumentException = Androidapi.JNI.JavaTypes.JIllegalArgumentException;
  JIllegalStateException = Androidapi.JNI.JavaTypes.JIllegalStateException;
  JInteger = Androidapi.JNI.JavaTypes.JInteger;
  JIterable = Androidapi.JNI.JavaTypes.JIterable;
  JLong = Androidapi.JNI.JavaTypes.JLong;
  JPackage = Androidapi.JNI.JavaTypes.JPackage;
  JRunnable = Androidapi.JNI.JavaTypes.JRunnable;
  JShort = Androidapi.JNI.JavaTypes.JShort;
  JStackTraceElement = Androidapi.JNI.JavaTypes.JStackTraceElement;
  JString = Androidapi.JNI.JavaTypes.JString;
  JStringBuffer = Androidapi.JNI.JavaTypes.JStringBuffer;
  JStringBuilder = Androidapi.JNI.JavaTypes.JStringBuilder;
  JThread = Androidapi.JNI.JavaTypes.JThread;
  JThread_State = Androidapi.JNI.JavaTypes.JThread_State;
  JThread_UncaughtExceptionHandler = Androidapi.JNI.JavaTypes.JThread_UncaughtExceptionHandler;
  JThreadGroup = Androidapi.JNI.JavaTypes.JThreadGroup;
  JThreadLocal = Androidapi.JNI.JavaTypes.JThreadLocal;
  JVoid = Androidapi.JNI.JavaTypes.JVoid;
  JAnnotation = Androidapi.JNI.JavaTypes.JAnnotation;
  JReference = Androidapi.JNI.JavaTypes.JReference;
  JReferenceQueue = Androidapi.JNI.JavaTypes.JReferenceQueue;
  JWeakReference = Androidapi.JNI.JavaTypes.JWeakReference;
  JAccessibleObject = Androidapi.JNI.JavaTypes.JAccessibleObject;
  JAnnotatedElement = Androidapi.JNI.JavaTypes.JAnnotatedElement;
  JExecutable = Androidapi.JNI.JavaTypes.JExecutable;
  JConstructor = Androidapi.JNI.JavaTypes.JConstructor;
  JField = Androidapi.JNI.JavaTypes.JField;
  JGenericDeclaration = Androidapi.JNI.JavaTypes.JGenericDeclaration;
  JMethod = Androidapi.JNI.JavaTypes.JMethod;
  JParameter = Androidapi.JNI.JavaTypes.JParameter;
  Jreflect_Type = Androidapi.JNI.JavaTypes.Jreflect_Type;
  JTypeVariable = Androidapi.JNI.JavaTypes.JTypeVariable;
  JBigInteger = Androidapi.JNI.JavaTypes.JBigInteger;
  JBuffer = Androidapi.JNI.JavaTypes.JBuffer;
  JByteBuffer = Androidapi.JNI.JavaTypes.JByteBuffer;
  JByteOrder = Androidapi.JNI.JavaTypes.JByteOrder;
  JCharBuffer = Androidapi.JNI.JavaTypes.JCharBuffer;
  JDoubleBuffer = Androidapi.JNI.JavaTypes.JDoubleBuffer;
  JFloatBuffer = Androidapi.JNI.JavaTypes.JFloatBuffer;
  JIntBuffer = Androidapi.JNI.JavaTypes.JIntBuffer;
  JLongBuffer = Androidapi.JNI.JavaTypes.JLongBuffer;
  JMappedByteBuffer = Androidapi.JNI.JavaTypes.JMappedByteBuffer;
  JShortBuffer = Androidapi.JNI.JavaTypes.JShortBuffer;
  JAsynchronousFileChannel = Androidapi.JNI.JavaTypes.JAsynchronousFileChannel;
  JChannel = Androidapi.JNI.JavaTypes.JChannel;
  JReadableByteChannel = Androidapi.JNI.JavaTypes.JReadableByteChannel;
  JByteChannel = Androidapi.JNI.JavaTypes.JByteChannel;
  JCompletionHandler = Androidapi.JNI.JavaTypes.JCompletionHandler;
  JAbstractInterruptibleChannel = Androidapi.JNI.JavaTypes.JAbstractInterruptibleChannel;
  JSelectableChannel = Androidapi.JNI.JavaTypes.JSelectableChannel;
  JAbstractSelectableChannel = Androidapi.JNI.JavaTypes.JAbstractSelectableChannel;
  JDatagramChannel = Androidapi.JNI.JavaTypes.JDatagramChannel;
  JFileChannel = Androidapi.JNI.JavaTypes.JFileChannel;
  JFileChannel_MapMode = Androidapi.JNI.JavaTypes.JFileChannel_MapMode;
  JFileLock = Androidapi.JNI.JavaTypes.JFileLock;
  JPipe = Androidapi.JNI.JavaTypes.JPipe;
  JPipe_SinkChannel = Androidapi.JNI.JavaTypes.JPipe_SinkChannel;
  JPipe_SourceChannel = Androidapi.JNI.JavaTypes.JPipe_SourceChannel;
  JSeekableByteChannel = Androidapi.JNI.JavaTypes.JSeekableByteChannel;
  JSelectionKey = Androidapi.JNI.JavaTypes.JSelectionKey;
  JSelector = Androidapi.JNI.JavaTypes.JSelector;
  JServerSocketChannel = Androidapi.JNI.JavaTypes.JServerSocketChannel;
  JSocketChannel = Androidapi.JNI.JavaTypes.JSocketChannel;
  JWritableByteChannel = Androidapi.JNI.JavaTypes.JWritableByteChannel;
  JAbstractSelector = Androidapi.JNI.JavaTypes.JAbstractSelector;
  JSelectorProvider = Androidapi.JNI.JavaTypes.JSelectorProvider;
  JCharset = Androidapi.JNI.JavaTypes.JCharset;
  JCharsetDecoder = Androidapi.JNI.JavaTypes.JCharsetDecoder;
  JCharsetEncoder = Androidapi.JNI.JavaTypes.JCharsetEncoder;
  JCoderResult = Androidapi.JNI.JavaTypes.JCoderResult;
  JCodingErrorAction = Androidapi.JNI.JavaTypes.JCodingErrorAction;
  JStandardCharsets = Androidapi.JNI.JavaTypes.JStandardCharsets;
  JAccessMode = Androidapi.JNI.JavaTypes.JAccessMode;
  JCopyOption = Androidapi.JNI.JavaTypes.JCopyOption;
  JDirectoryStream = Androidapi.JNI.JavaTypes.JDirectoryStream;
  JDirectoryStream_Filter = Androidapi.JNI.JavaTypes.JDirectoryStream_Filter;
  JFileStore = Androidapi.JNI.JavaTypes.JFileStore;
  JFileSystem = Androidapi.JNI.JavaTypes.JFileSystem;
  JLinkOption = Androidapi.JNI.JavaTypes.JLinkOption;
  JOpenOption = Androidapi.JNI.JavaTypes.JOpenOption;
  Jfile_Path = Androidapi.JNI.JavaTypes.Jfile_Path;
  JPathMatcher = Androidapi.JNI.JavaTypes.JPathMatcher;
  JWatchEvent_Kind = Androidapi.JNI.JavaTypes.JWatchEvent_Kind;
  JWatchEvent_Modifier = Androidapi.JNI.JavaTypes.JWatchEvent_Modifier;
  JWatchKey = Androidapi.JNI.JavaTypes.JWatchKey;
  JWatchService = Androidapi.JNI.JavaTypes.JWatchService;
  JWatchable = Androidapi.JNI.JavaTypes.JWatchable;
  JAttributeView = Androidapi.JNI.JavaTypes.JAttributeView;
  JBasicFileAttributes = Androidapi.JNI.JavaTypes.JBasicFileAttributes;
  JFileAttribute = Androidapi.JNI.JavaTypes.JFileAttribute;
  JFileAttributeView = Androidapi.JNI.JavaTypes.JFileAttributeView;
  JFileStoreAttributeView = Androidapi.JNI.JavaTypes.JFileStoreAttributeView;
  JFileTime = Androidapi.JNI.JavaTypes.JFileTime;
  JUserPrincipalLookupService = Androidapi.JNI.JavaTypes.JUserPrincipalLookupService;
  JFileSystemProvider = Androidapi.JNI.JavaTypes.JFileSystemProvider;
  JCharacterIterator = Androidapi.JNI.JavaTypes.JCharacterIterator;
  JAttributedCharacterIterator = Androidapi.JNI.JavaTypes.JAttributedCharacterIterator;
  JAttributedCharacterIterator_Attribute = Androidapi.JNI.JavaTypes.JAttributedCharacterIterator_Attribute;
  JFieldPosition = Androidapi.JNI.JavaTypes.JFieldPosition;
  JFormat = Androidapi.JNI.JavaTypes.JFormat;
  JFormat_Field = Androidapi.JNI.JavaTypes.JFormat_Field;
  JParsePosition = Androidapi.JNI.JavaTypes.JParsePosition;
  JClock = Androidapi.JNI.JavaTypes.JClock;
  JDayOfWeek = Androidapi.JNI.JavaTypes.JDayOfWeek;
  Jtime_Duration = Androidapi.JNI.JavaTypes.Jtime_Duration;
  JInstant = Androidapi.JNI.JavaTypes.JInstant;
  JLocalDate = Androidapi.JNI.JavaTypes.JLocalDate;
  JLocalDateTime = Androidapi.JNI.JavaTypes.JLocalDateTime;
  JLocalTime = Androidapi.JNI.JavaTypes.JLocalTime;
  JMonth = Androidapi.JNI.JavaTypes.JMonth;
  JOffsetDateTime = Androidapi.JNI.JavaTypes.JOffsetDateTime;
  JOffsetTime = Androidapi.JNI.JavaTypes.JOffsetTime;
  JPeriod = Androidapi.JNI.JavaTypes.JPeriod;
  JZoneId = Androidapi.JNI.JavaTypes.JZoneId;
  JZoneOffset = Androidapi.JNI.JavaTypes.JZoneOffset;
  JZonedDateTime = Androidapi.JNI.JavaTypes.JZonedDateTime;
  JAbstractChronology = Androidapi.JNI.JavaTypes.JAbstractChronology;
  JChronoLocalDate = Androidapi.JNI.JavaTypes.JChronoLocalDate;
  JChronoLocalDateTime = Androidapi.JNI.JavaTypes.JChronoLocalDateTime;
  JTemporalAmount = Androidapi.JNI.JavaTypes.JTemporalAmount;
  JChronoPeriod = Androidapi.JNI.JavaTypes.JChronoPeriod;
  JChronoZonedDateTime = Androidapi.JNI.JavaTypes.JChronoZonedDateTime;
  JChronology = Androidapi.JNI.JavaTypes.JChronology;
  JTemporalAccessor = Androidapi.JNI.JavaTypes.JTemporalAccessor;
  JEra = Androidapi.JNI.JavaTypes.JEra;
  JIsoChronology = Androidapi.JNI.JavaTypes.JIsoChronology;
  JIsoEra = Androidapi.JNI.JavaTypes.JIsoEra;
  JDateTimeFormatter = Androidapi.JNI.JavaTypes.JDateTimeFormatter;
  JDecimalStyle = Androidapi.JNI.JavaTypes.JDecimalStyle;
  JFormatStyle = Androidapi.JNI.JavaTypes.JFormatStyle;
  JResolverStyle = Androidapi.JNI.JavaTypes.JResolverStyle;
  JTextStyle = Androidapi.JNI.JavaTypes.JTextStyle;
  JChronoField = Androidapi.JNI.JavaTypes.JChronoField;
  JChronoUnit = Androidapi.JNI.JavaTypes.JChronoUnit;
  JTemporal = Androidapi.JNI.JavaTypes.JTemporal;
  JTemporalAdjuster = Androidapi.JNI.JavaTypes.JTemporalAdjuster;
  JTemporalField = Androidapi.JNI.JavaTypes.JTemporalField;
  JTemporalQuery = Androidapi.JNI.JavaTypes.JTemporalQuery;
  JTemporalUnit = Androidapi.JNI.JavaTypes.JTemporalUnit;
  JValueRange = Androidapi.JNI.JavaTypes.JValueRange;
  JZoneOffsetTransition = Androidapi.JNI.JavaTypes.JZoneOffsetTransition;
  JZoneRules = Androidapi.JNI.JavaTypes.JZoneRules;
  JAbstractCollection = Androidapi.JNI.JavaTypes.JAbstractCollection;
  JAbstractList = Androidapi.JNI.JavaTypes.JAbstractList;
  JAbstractMap = Androidapi.JNI.JavaTypes.JAbstractMap;
  JAbstractSet = Androidapi.JNI.JavaTypes.JAbstractSet;
  JArrayList = Androidapi.JNI.JavaTypes.JArrayList;
  JBitSet = Androidapi.JNI.JavaTypes.JBitSet;
  JCalendar = Androidapi.JNI.JavaTypes.JCalendar;
  JCollection = Androidapi.JNI.JavaTypes.JCollection;
  JCollections = Androidapi.JNI.JavaTypes.JCollections;
  JComparator = Androidapi.JNI.JavaTypes.JComparator;
  JDate = Androidapi.JNI.JavaTypes.JDate;
  JQueue = Androidapi.JNI.JavaTypes.JQueue;
  JDeque = Androidapi.JNI.JavaTypes.JDeque;
  JDictionary = Androidapi.JNI.JavaTypes.JDictionary;
  JDoubleSummaryStatistics = Androidapi.JNI.JavaTypes.JDoubleSummaryStatistics;
  JEnumSet = Androidapi.JNI.JavaTypes.JEnumSet;
  JEnumeration = Androidapi.JNI.JavaTypes.JEnumeration;
  JEventListener = Androidapi.JNI.JavaTypes.JEventListener;
  JEventObject = Androidapi.JNI.JavaTypes.JEventObject;
  JGregorianCalendar = Androidapi.JNI.JavaTypes.JGregorianCalendar;
  JHashMap = Androidapi.JNI.JavaTypes.JHashMap;
  JHashSet = Androidapi.JNI.JavaTypes.JHashSet;
  JHashtable = Androidapi.JNI.JavaTypes.JHashtable;
  JIntSummaryStatistics = Androidapi.JNI.JavaTypes.JIntSummaryStatistics;
  JIterator = Androidapi.JNI.JavaTypes.JIterator;
  JList = Androidapi.JNI.JavaTypes.JList;
  JListIterator = Androidapi.JNI.JavaTypes.JListIterator;
  JLocale = Androidapi.JNI.JavaTypes.JLocale;
  JLocale_Category = Androidapi.JNI.JavaTypes.JLocale_Category;
  JLocale_FilteringMode = Androidapi.JNI.JavaTypes.JLocale_FilteringMode;
  JLongSummaryStatistics = Androidapi.JNI.JavaTypes.JLongSummaryStatistics;
  JMap = Androidapi.JNI.JavaTypes.JMap;
  JMap_Entry = Androidapi.JNI.JavaTypes.JMap_Entry;
  JSortedMap = Androidapi.JNI.JavaTypes.JSortedMap;
  JNavigableMap = Androidapi.JNI.JavaTypes.JNavigableMap;
  JSet = Androidapi.JNI.JavaTypes.JSet;
  JSortedSet = Androidapi.JNI.JavaTypes.JSortedSet;
  JNavigableSet = Androidapi.JNI.JavaTypes.JNavigableSet;
  Jutil_Observable = Androidapi.JNI.JavaTypes.Jutil_Observable;
  JObserver = Androidapi.JNI.JavaTypes.JObserver;
  JOptional = Androidapi.JNI.JavaTypes.JOptional;
  JOptionalDouble = Androidapi.JNI.JavaTypes.JOptionalDouble;
  JOptionalInt = Androidapi.JNI.JavaTypes.JOptionalInt;
  JOptionalLong = Androidapi.JNI.JavaTypes.JOptionalLong;
  JPrimitiveIterator = Androidapi.JNI.JavaTypes.JPrimitiveIterator;
  JPrimitiveIterator_OfDouble = Androidapi.JNI.JavaTypes.JPrimitiveIterator_OfDouble;
  JPrimitiveIterator_OfInt = Androidapi.JNI.JavaTypes.JPrimitiveIterator_OfInt;
  JPrimitiveIterator_OfLong = Androidapi.JNI.JavaTypes.JPrimitiveIterator_OfLong;
  JProperties = Androidapi.JNI.JavaTypes.JProperties;
  JRandom = Androidapi.JNI.JavaTypes.JRandom;
  JSpliterator = Androidapi.JNI.JavaTypes.JSpliterator;
  JSpliterator_OfPrimitive = Androidapi.JNI.JavaTypes.JSpliterator_OfPrimitive;
  JSpliterator_OfDouble = Androidapi.JNI.JavaTypes.JSpliterator_OfDouble;
  JSpliterator_OfInt = Androidapi.JNI.JavaTypes.JSpliterator_OfInt;
  JSpliterator_OfLong = Androidapi.JNI.JavaTypes.JSpliterator_OfLong;
  JTimeZone = Androidapi.JNI.JavaTypes.JTimeZone;
  JTimer = Androidapi.JNI.JavaTypes.JTimer;
  JTimerTask = Androidapi.JNI.JavaTypes.JTimerTask;
  JUUID = Androidapi.JNI.JavaTypes.JUUID;
  JAbstractExecutorService = Androidapi.JNI.JavaTypes.JAbstractExecutorService;
  JBlockingQueue = Androidapi.JNI.JavaTypes.JBlockingQueue;
  JCallable = Androidapi.JNI.JavaTypes.JCallable;
  JCountDownLatch = Androidapi.JNI.JavaTypes.JCountDownLatch;
  JDelayed = Androidapi.JNI.JavaTypes.JDelayed;
  JExecutor = Androidapi.JNI.JavaTypes.JExecutor;
  JExecutorService = Androidapi.JNI.JavaTypes.JExecutorService;
  JFuture = Androidapi.JNI.JavaTypes.JFuture;
  JRejectedExecutionHandler = Androidapi.JNI.JavaTypes.JRejectedExecutionHandler;
  JScheduledExecutorService = Androidapi.JNI.JavaTypes.JScheduledExecutorService;
  JScheduledFuture = Androidapi.JNI.JavaTypes.JScheduledFuture;
  JThreadPoolExecutor = Androidapi.JNI.JavaTypes.JThreadPoolExecutor;
  JScheduledThreadPoolExecutor = Androidapi.JNI.JavaTypes.JScheduledThreadPoolExecutor;
  JThreadFactory = Androidapi.JNI.JavaTypes.JThreadFactory;
  JTimeUnit = Androidapi.JNI.JavaTypes.JTimeUnit;
  JAtomicBoolean = Androidapi.JNI.JavaTypes.JAtomicBoolean;
  JAtomicReference = Androidapi.JNI.JavaTypes.JAtomicReference;
  JBiConsumer = Androidapi.JNI.JavaTypes.JBiConsumer;
  JBiFunction = Androidapi.JNI.JavaTypes.JBiFunction;
  JBinaryOperator = Androidapi.JNI.JavaTypes.JBinaryOperator;
  JConsumer = Androidapi.JNI.JavaTypes.JConsumer;
  JDoubleBinaryOperator = Androidapi.JNI.JavaTypes.JDoubleBinaryOperator;
  JDoubleConsumer = Androidapi.JNI.JavaTypes.JDoubleConsumer;
  JDoubleFunction = Androidapi.JNI.JavaTypes.JDoubleFunction;
  JDoublePredicate = Androidapi.JNI.JavaTypes.JDoublePredicate;
  JDoubleSupplier = Androidapi.JNI.JavaTypes.JDoubleSupplier;
  JDoubleToIntFunction = Androidapi.JNI.JavaTypes.JDoubleToIntFunction;
  JDoubleToLongFunction = Androidapi.JNI.JavaTypes.JDoubleToLongFunction;
  JDoubleUnaryOperator = Androidapi.JNI.JavaTypes.JDoubleUnaryOperator;
  JFunction = Androidapi.JNI.JavaTypes.JFunction;
  JIntBinaryOperator = Androidapi.JNI.JavaTypes.JIntBinaryOperator;
  JIntConsumer = Androidapi.JNI.JavaTypes.JIntConsumer;
  JIntFunction = Androidapi.JNI.JavaTypes.JIntFunction;
  JIntPredicate = Androidapi.JNI.JavaTypes.JIntPredicate;
  JIntSupplier = Androidapi.JNI.JavaTypes.JIntSupplier;
  JIntToDoubleFunction = Androidapi.JNI.JavaTypes.JIntToDoubleFunction;
  JIntToLongFunction = Androidapi.JNI.JavaTypes.JIntToLongFunction;
  JIntUnaryOperator = Androidapi.JNI.JavaTypes.JIntUnaryOperator;
  JLongBinaryOperator = Androidapi.JNI.JavaTypes.JLongBinaryOperator;
  JLongConsumer = Androidapi.JNI.JavaTypes.JLongConsumer;
  JLongFunction = Androidapi.JNI.JavaTypes.JLongFunction;
  JLongPredicate = Androidapi.JNI.JavaTypes.JLongPredicate;
  JLongSupplier = Androidapi.JNI.JavaTypes.JLongSupplier;
  JLongToDoubleFunction = Androidapi.JNI.JavaTypes.JLongToDoubleFunction;
  JLongToIntFunction = Androidapi.JNI.JavaTypes.JLongToIntFunction;
  JLongUnaryOperator = Androidapi.JNI.JavaTypes.JLongUnaryOperator;
  JObjDoubleConsumer = Androidapi.JNI.JavaTypes.JObjDoubleConsumer;
  JObjIntConsumer = Androidapi.JNI.JavaTypes.JObjIntConsumer;
  JObjLongConsumer = Androidapi.JNI.JavaTypes.JObjLongConsumer;
  Jfunction_Predicate = Androidapi.JNI.JavaTypes.Jfunction_Predicate;
  JSupplier = Androidapi.JNI.JavaTypes.JSupplier;
  JToDoubleFunction = Androidapi.JNI.JavaTypes.JToDoubleFunction;
  JToIntFunction = Androidapi.JNI.JavaTypes.JToIntFunction;
  JToLongFunction = Androidapi.JNI.JavaTypes.JToLongFunction;
  JUnaryOperator = Androidapi.JNI.JavaTypes.JUnaryOperator;
  JBaseStream = Androidapi.JNI.JavaTypes.JBaseStream;
  JCollector = Androidapi.JNI.JavaTypes.JCollector;
  JCollector_Characteristics = Androidapi.JNI.JavaTypes.JCollector_Characteristics;
  JDoubleStream = Androidapi.JNI.JavaTypes.JDoubleStream;
  JDoubleStream_Builder = Androidapi.JNI.JavaTypes.JDoubleStream_Builder;
  JIntStream = Androidapi.JNI.JavaTypes.JIntStream;
  JIntStream_Builder = Androidapi.JNI.JavaTypes.JIntStream_Builder;
  JLongStream = Androidapi.JNI.JavaTypes.JLongStream;
  JLongStream_Builder = Androidapi.JNI.JavaTypes.JLongStream_Builder;
  JStream = Androidapi.JNI.JavaTypes.JStream;
  JStream_Builder = Androidapi.JNI.JavaTypes.JStream_Builder;
  JCipher = Androidapi.JNI.JavaTypes.JCipher;
  JExemptionMechanism = Androidapi.JNI.JavaTypes.JExemptionMechanism;
  JMac = Androidapi.JNI.JavaTypes.JMac;
  JEGL = Androidapi.JNI.JavaTypes.JEGL;
  JEGL10 = Androidapi.JNI.JavaTypes.JEGL10;
  JEGLConfig = Androidapi.JNI.JavaTypes.JEGLConfig;
  JEGLContext = Androidapi.JNI.JavaTypes.JEGLContext;
  JEGLDisplay = Androidapi.JNI.JavaTypes.JEGLDisplay;
  JEGLSurface = Androidapi.JNI.JavaTypes.JEGLSurface;
  JGL = Androidapi.JNI.JavaTypes.JGL;
  JGL10 = Androidapi.JNI.JavaTypes.JGL10;
  JJSONArray = Androidapi.JNI.JavaTypes.JJSONArray;
  JJSONException = Androidapi.JNI.JavaTypes.JJSONException;
  JJSONObject = Androidapi.JNI.JavaTypes.JJSONObject;
  JJSONTokener = Androidapi.JNI.JavaTypes.JJSONTokener;
  JXmlPullParser = Androidapi.JNI.JavaTypes.JXmlPullParser;
  JXmlSerializer = Androidapi.JNI.JavaTypes.JXmlSerializer;


  TJObject = Androidapi.JNI.JavaTypes.TJObject;
  TJInputStream = Androidapi.JNI.JavaTypes.TJInputStream;
  TJByteArrayInputStream = Androidapi.JNI.JavaTypes.TJByteArrayInputStream;
  TJOutputStream = Androidapi.JNI.JavaTypes.TJOutputStream;
  TJByteArrayOutputStream = Androidapi.JNI.JavaTypes.TJByteArrayOutputStream;
  TJAutoCloseable = Androidapi.JNI.JavaTypes.TJAutoCloseable;
  TJCloseable = Androidapi.JNI.JavaTypes.TJCloseable;
  TJFile = Androidapi.JNI.JavaTypes.TJFile;
  TJFileDescriptor = Androidapi.JNI.JavaTypes.TJFileDescriptor;
  TJFileFilter = Androidapi.JNI.JavaTypes.TJFileFilter;
  TJFileInputStream = Androidapi.JNI.JavaTypes.TJFileInputStream;
  TJFileOutputStream = Androidapi.JNI.JavaTypes.TJFileOutputStream;
  TJFilenameFilter = Androidapi.JNI.JavaTypes.TJFilenameFilter;
  TJFilterOutputStream = Androidapi.JNI.JavaTypes.TJFilterOutputStream;
  TJThrowable = Androidapi.JNI.JavaTypes.TJThrowable;
  TJException = Androidapi.JNI.JavaTypes.TJException;
  TJIOException = Androidapi.JNI.JavaTypes.TJIOException;
  TJPrintStream = Androidapi.JNI.JavaTypes.TJPrintStream;
  TJWriter = Androidapi.JNI.JavaTypes.TJWriter;
  TJPrintWriter = Androidapi.JNI.JavaTypes.TJPrintWriter;
  TJRandomAccessFile = Androidapi.JNI.JavaTypes.TJRandomAccessFile;
  TJReader = Androidapi.JNI.JavaTypes.TJReader;
  TJSerializable = Androidapi.JNI.JavaTypes.TJSerializable;
  TJAbstractStringBuilder = Androidapi.JNI.JavaTypes.TJAbstractStringBuilder;
  TJAppendable = Androidapi.JNI.JavaTypes.TJAppendable;
  TJBoolean = Androidapi.JNI.JavaTypes.TJBoolean;
  TJNumber = Androidapi.JNI.JavaTypes.TJNumber;
  TJByte = Androidapi.JNI.JavaTypes.TJByte;
  TJCharSequence = Androidapi.JNI.JavaTypes.TJCharSequence;
  TJlang_Class = Androidapi.JNI.JavaTypes.TJlang_Class;
  TJClassLoader = Androidapi.JNI.JavaTypes.TJClassLoader;
  TJCloneable = Androidapi.JNI.JavaTypes.TJCloneable;
  TJComparable = Androidapi.JNI.JavaTypes.TJComparable;
  TJDouble = Androidapi.JNI.JavaTypes.TJDouble;
  TJEnum = Androidapi.JNI.JavaTypes.TJEnum;
  TJFloat = Androidapi.JNI.JavaTypes.TJFloat;
  TJRuntimeException = Androidapi.JNI.JavaTypes.TJRuntimeException;
  TJIllegalArgumentException = Androidapi.JNI.JavaTypes.TJIllegalArgumentException;
  TJIllegalStateException = Androidapi.JNI.JavaTypes.TJIllegalStateException;
  TJInteger = Androidapi.JNI.JavaTypes.TJInteger;
  TJIterable = Androidapi.JNI.JavaTypes.TJIterable;
  TJLong = Androidapi.JNI.JavaTypes.TJLong;
  TJPackage = Androidapi.JNI.JavaTypes.TJPackage;
  TJRunnable = Androidapi.JNI.JavaTypes.TJRunnable;
  TJShort = Androidapi.JNI.JavaTypes.TJShort;
  TJStackTraceElement = Androidapi.JNI.JavaTypes.TJStackTraceElement;
  TJString = Androidapi.JNI.JavaTypes.TJString;
  TJStringBuffer = Androidapi.JNI.JavaTypes.TJStringBuffer;
  TJStringBuilder = Androidapi.JNI.JavaTypes.TJStringBuilder;
  TJThread = Androidapi.JNI.JavaTypes.TJThread;
  TJThread_State = Androidapi.JNI.JavaTypes.TJThread_State;
  TJThread_UncaughtExceptionHandler = Androidapi.JNI.JavaTypes.TJThread_UncaughtExceptionHandler;
  TJThreadGroup = Androidapi.JNI.JavaTypes.TJThreadGroup;
  TJThreadLocal = Androidapi.JNI.JavaTypes.TJThreadLocal;
  TJVoid = Androidapi.JNI.JavaTypes.TJVoid;
  TJAnnotation = Androidapi.JNI.JavaTypes.TJAnnotation;
  TJReference = Androidapi.JNI.JavaTypes.TJReference;
  TJReferenceQueue = Androidapi.JNI.JavaTypes.TJReferenceQueue;
  TJWeakReference = Androidapi.JNI.JavaTypes.TJWeakReference;
  TJAccessibleObject = Androidapi.JNI.JavaTypes.TJAccessibleObject;
  TJAnnotatedElement = Androidapi.JNI.JavaTypes.TJAnnotatedElement;
  TJExecutable = Androidapi.JNI.JavaTypes.TJExecutable;
  TJConstructor = Androidapi.JNI.JavaTypes.TJConstructor;
  TJField = Androidapi.JNI.JavaTypes.TJField;
  TJGenericDeclaration = Androidapi.JNI.JavaTypes.TJGenericDeclaration;
  TJMethod = Androidapi.JNI.JavaTypes.TJMethod;
  TJParameter = Androidapi.JNI.JavaTypes.TJParameter;
  TJreflect_Type = Androidapi.JNI.JavaTypes.TJreflect_Type;
  TJTypeVariable = Androidapi.JNI.JavaTypes.TJTypeVariable;
  TJBigInteger = Androidapi.JNI.JavaTypes.TJBigInteger;
  TJBuffer = Androidapi.JNI.JavaTypes.TJBuffer;
  TJByteBuffer = Androidapi.JNI.JavaTypes.TJByteBuffer;
  TJByteOrder = Androidapi.JNI.JavaTypes.TJByteOrder;
  TJCharBuffer = Androidapi.JNI.JavaTypes.TJCharBuffer;
  TJDoubleBuffer = Androidapi.JNI.JavaTypes.TJDoubleBuffer;
  TJFloatBuffer = Androidapi.JNI.JavaTypes.TJFloatBuffer;
  TJIntBuffer = Androidapi.JNI.JavaTypes.TJIntBuffer;
  TJLongBuffer = Androidapi.JNI.JavaTypes.TJLongBuffer;
  TJMappedByteBuffer = Androidapi.JNI.JavaTypes.TJMappedByteBuffer;
  TJShortBuffer = Androidapi.JNI.JavaTypes.TJShortBuffer;
  TJAsynchronousFileChannel = Androidapi.JNI.JavaTypes.TJAsynchronousFileChannel;
  TJChannel = Androidapi.JNI.JavaTypes.TJChannel;
  TJReadableByteChannel = Androidapi.JNI.JavaTypes.TJReadableByteChannel;
  TJByteChannel = Androidapi.JNI.JavaTypes.TJByteChannel;
  TJCompletionHandler = Androidapi.JNI.JavaTypes.TJCompletionHandler;
  TJAbstractInterruptibleChannel = Androidapi.JNI.JavaTypes.TJAbstractInterruptibleChannel;
  TJSelectableChannel = Androidapi.JNI.JavaTypes.TJSelectableChannel;
  TJAbstractSelectableChannel = Androidapi.JNI.JavaTypes.TJAbstractSelectableChannel;
  TJDatagramChannel = Androidapi.JNI.JavaTypes.TJDatagramChannel;
  TJFileChannel = Androidapi.JNI.JavaTypes.TJFileChannel;
  TJFileChannel_MapMode = Androidapi.JNI.JavaTypes.TJFileChannel_MapMode;
  TJFileLock = Androidapi.JNI.JavaTypes.TJFileLock;
  TJPipe = Androidapi.JNI.JavaTypes.TJPipe;
  TJPipe_SinkChannel = Androidapi.JNI.JavaTypes.TJPipe_SinkChannel;
  TJPipe_SourceChannel = Androidapi.JNI.JavaTypes.TJPipe_SourceChannel;
  TJSeekableByteChannel = Androidapi.JNI.JavaTypes.TJSeekableByteChannel;
  TJSelectionKey = Androidapi.JNI.JavaTypes.TJSelectionKey;
  TJSelector = Androidapi.JNI.JavaTypes.TJSelector;
  TJServerSocketChannel = Androidapi.JNI.JavaTypes.TJServerSocketChannel;
  TJSocketChannel = Androidapi.JNI.JavaTypes.TJSocketChannel;
  TJWritableByteChannel = Androidapi.JNI.JavaTypes.TJWritableByteChannel;
  TJAbstractSelector = Androidapi.JNI.JavaTypes.TJAbstractSelector;
  TJSelectorProvider = Androidapi.JNI.JavaTypes.TJSelectorProvider;
  TJCharset = Androidapi.JNI.JavaTypes.TJCharset;
  TJCharsetDecoder = Androidapi.JNI.JavaTypes.TJCharsetDecoder;
  TJCharsetEncoder = Androidapi.JNI.JavaTypes.TJCharsetEncoder;
  TJCoderResult = Androidapi.JNI.JavaTypes.TJCoderResult;
  TJCodingErrorAction = Androidapi.JNI.JavaTypes.TJCodingErrorAction;
  TJStandardCharsets = Androidapi.JNI.JavaTypes.TJStandardCharsets;
  TJAccessMode = Androidapi.JNI.JavaTypes.TJAccessMode;
  TJCopyOption = Androidapi.JNI.JavaTypes.TJCopyOption;
  TJDirectoryStream = Androidapi.JNI.JavaTypes.TJDirectoryStream;
  TJDirectoryStream_Filter = Androidapi.JNI.JavaTypes.TJDirectoryStream_Filter;
  TJFileStore = Androidapi.JNI.JavaTypes.TJFileStore;
  TJFileSystem = Androidapi.JNI.JavaTypes.TJFileSystem;
  TJLinkOption = Androidapi.JNI.JavaTypes.TJLinkOption;
  TJOpenOption = Androidapi.JNI.JavaTypes.TJOpenOption;
  TJfile_Path = Androidapi.JNI.JavaTypes.TJfile_Path;
  TJPathMatcher = Androidapi.JNI.JavaTypes.TJPathMatcher;
  TJWatchEvent_Kind = Androidapi.JNI.JavaTypes.TJWatchEvent_Kind;
  TJWatchEvent_Modifier = Androidapi.JNI.JavaTypes.TJWatchEvent_Modifier;
  TJWatchKey = Androidapi.JNI.JavaTypes.TJWatchKey;
  TJWatchService = Androidapi.JNI.JavaTypes.TJWatchService;
  TJWatchable = Androidapi.JNI.JavaTypes.TJWatchable;
  TJAttributeView = Androidapi.JNI.JavaTypes.TJAttributeView;
  TJBasicFileAttributes = Androidapi.JNI.JavaTypes.TJBasicFileAttributes;
  TJFileAttribute = Androidapi.JNI.JavaTypes.TJFileAttribute;
  TJFileAttributeView = Androidapi.JNI.JavaTypes.TJFileAttributeView;
  TJFileStoreAttributeView = Androidapi.JNI.JavaTypes.TJFileStoreAttributeView;
  TJFileTime = Androidapi.JNI.JavaTypes.TJFileTime;
  TJUserPrincipalLookupService = Androidapi.JNI.JavaTypes.TJUserPrincipalLookupService;
  TJFileSystemProvider = Androidapi.JNI.JavaTypes.TJFileSystemProvider;
  TJCharacterIterator = Androidapi.JNI.JavaTypes.TJCharacterIterator;
  TJAttributedCharacterIterator = Androidapi.JNI.JavaTypes.TJAttributedCharacterIterator;
  TJAttributedCharacterIterator_Attribute = Androidapi.JNI.JavaTypes.TJAttributedCharacterIterator_Attribute;
  TJFieldPosition = Androidapi.JNI.JavaTypes.TJFieldPosition;
  TJFormat = Androidapi.JNI.JavaTypes.TJFormat;
  TJFormat_Field = Androidapi.JNI.JavaTypes.TJFormat_Field;
  TJParsePosition = Androidapi.JNI.JavaTypes.TJParsePosition;
  TJClock = Androidapi.JNI.JavaTypes.TJClock;
  TJDayOfWeek = Androidapi.JNI.JavaTypes.TJDayOfWeek;
  TJtime_Duration = Androidapi.JNI.JavaTypes.TJtime_Duration;
  TJInstant = Androidapi.JNI.JavaTypes.TJInstant;
  TJLocalDate = Androidapi.JNI.JavaTypes.TJLocalDate;
  TJLocalDateTime = Androidapi.JNI.JavaTypes.TJLocalDateTime;
  TJLocalTime = Androidapi.JNI.JavaTypes.TJLocalTime;
  TJMonth = Androidapi.JNI.JavaTypes.TJMonth;
  TJOffsetDateTime = Androidapi.JNI.JavaTypes.TJOffsetDateTime;
  TJOffsetTime = Androidapi.JNI.JavaTypes.TJOffsetTime;
  TJPeriod = Androidapi.JNI.JavaTypes.TJPeriod;
  TJZoneId = Androidapi.JNI.JavaTypes.TJZoneId;
  TJZoneOffset = Androidapi.JNI.JavaTypes.TJZoneOffset;
  TJZonedDateTime = Androidapi.JNI.JavaTypes.TJZonedDateTime;
  TJAbstractChronology = Androidapi.JNI.JavaTypes.TJAbstractChronology;
  TJChronoLocalDate = Androidapi.JNI.JavaTypes.TJChronoLocalDate;
  TJChronoLocalDateTime = Androidapi.JNI.JavaTypes.TJChronoLocalDateTime;
  TJTemporalAmount = Androidapi.JNI.JavaTypes.TJTemporalAmount;
  TJChronoPeriod = Androidapi.JNI.JavaTypes.TJChronoPeriod;
  TJChronoZonedDateTime = Androidapi.JNI.JavaTypes.TJChronoZonedDateTime;
  TJChronology = Androidapi.JNI.JavaTypes.TJChronology;
  TJTemporalAccessor = Androidapi.JNI.JavaTypes.TJTemporalAccessor;
  TJEra = Androidapi.JNI.JavaTypes.TJEra;
  TJIsoChronology = Androidapi.JNI.JavaTypes.TJIsoChronology;
  TJIsoEra = Androidapi.JNI.JavaTypes.TJIsoEra;
  TJDateTimeFormatter = Androidapi.JNI.JavaTypes.TJDateTimeFormatter;
  TJDecimalStyle = Androidapi.JNI.JavaTypes.TJDecimalStyle;
  TJFormatStyle = Androidapi.JNI.JavaTypes.TJFormatStyle;
  TJResolverStyle = Androidapi.JNI.JavaTypes.TJResolverStyle;
  TJTextStyle = Androidapi.JNI.JavaTypes.TJTextStyle;
  TJChronoField = Androidapi.JNI.JavaTypes.TJChronoField;
  TJChronoUnit = Androidapi.JNI.JavaTypes.TJChronoUnit;
  TJTemporal = Androidapi.JNI.JavaTypes.TJTemporal;
  TJTemporalAdjuster = Androidapi.JNI.JavaTypes.TJTemporalAdjuster;
  TJTemporalField = Androidapi.JNI.JavaTypes.TJTemporalField;
  TJTemporalQuery = Androidapi.JNI.JavaTypes.TJTemporalQuery;
  TJTemporalUnit = Androidapi.JNI.JavaTypes.TJTemporalUnit;
  TJValueRange = Androidapi.JNI.JavaTypes.TJValueRange;
  TJZoneOffsetTransition = Androidapi.JNI.JavaTypes.TJZoneOffsetTransition;
  TJZoneRules = Androidapi.JNI.JavaTypes.TJZoneRules;
  TJAbstractCollection = Androidapi.JNI.JavaTypes.TJAbstractCollection;
  TJAbstractList = Androidapi.JNI.JavaTypes.TJAbstractList;
  TJAbstractMap = Androidapi.JNI.JavaTypes.TJAbstractMap;
  TJAbstractSet = Androidapi.JNI.JavaTypes.TJAbstractSet;
  TJArrayList = Androidapi.JNI.JavaTypes.TJArrayList;
  TJBitSet = Androidapi.JNI.JavaTypes.TJBitSet;
  TJCalendar = Androidapi.JNI.JavaTypes.TJCalendar;
  TJCollection = Androidapi.JNI.JavaTypes.TJCollection;
  TJCollections = Androidapi.JNI.JavaTypes.TJCollections;
  TJComparator = Androidapi.JNI.JavaTypes.TJComparator;
  TJDate = Androidapi.JNI.JavaTypes.TJDate;
  TJQueue = Androidapi.JNI.JavaTypes.TJQueue;
  TJDeque = Androidapi.JNI.JavaTypes.TJDeque;
  TJDictionary = Androidapi.JNI.JavaTypes.TJDictionary;
  TJDoubleSummaryStatistics = Androidapi.JNI.JavaTypes.TJDoubleSummaryStatistics;
  TJEnumSet = Androidapi.JNI.JavaTypes.TJEnumSet;
  TJEnumeration = Androidapi.JNI.JavaTypes.TJEnumeration;
  TJEventListener = Androidapi.JNI.JavaTypes.TJEventListener;
  TJEventObject = Androidapi.JNI.JavaTypes.TJEventObject;
  TJGregorianCalendar = Androidapi.JNI.JavaTypes.TJGregorianCalendar;
  TJHashMap = Androidapi.JNI.JavaTypes.TJHashMap;
  TJHashSet = Androidapi.JNI.JavaTypes.TJHashSet;
  TJHashtable = Androidapi.JNI.JavaTypes.TJHashtable;
  TJIntSummaryStatistics = Androidapi.JNI.JavaTypes.TJIntSummaryStatistics;
  TJIterator = Androidapi.JNI.JavaTypes.TJIterator;
  TJList = Androidapi.JNI.JavaTypes.TJList;
  TJListIterator = Androidapi.JNI.JavaTypes.TJListIterator;
  TJLocale = Androidapi.JNI.JavaTypes.TJLocale;
  TJLocale_Category = Androidapi.JNI.JavaTypes.TJLocale_Category;
  TJLocale_FilteringMode = Androidapi.JNI.JavaTypes.TJLocale_FilteringMode;
  TJLongSummaryStatistics = Androidapi.JNI.JavaTypes.TJLongSummaryStatistics;
  TJMap = Androidapi.JNI.JavaTypes.TJMap;
  TJMap_Entry = Androidapi.JNI.JavaTypes.TJMap_Entry;
  TJSortedMap = Androidapi.JNI.JavaTypes.TJSortedMap;
  TJNavigableMap = Androidapi.JNI.JavaTypes.TJNavigableMap;
  TJSet = Androidapi.JNI.JavaTypes.TJSet;
  TJSortedSet = Androidapi.JNI.JavaTypes.TJSortedSet;
  TJNavigableSet = Androidapi.JNI.JavaTypes.TJNavigableSet;
  TJutil_Observable = Androidapi.JNI.JavaTypes.TJutil_Observable;
  TJObserver = Androidapi.JNI.JavaTypes.TJObserver;
  TJOptional = Androidapi.JNI.JavaTypes.TJOptional;
  TJOptionalDouble = Androidapi.JNI.JavaTypes.TJOptionalDouble;
  TJOptionalInt = Androidapi.JNI.JavaTypes.TJOptionalInt;
  TJOptionalLong = Androidapi.JNI.JavaTypes.TJOptionalLong;
  TJPrimitiveIterator = Androidapi.JNI.JavaTypes.TJPrimitiveIterator;
  TJPrimitiveIterator_OfDouble = Androidapi.JNI.JavaTypes.TJPrimitiveIterator_OfDouble;
  TJPrimitiveIterator_OfInt = Androidapi.JNI.JavaTypes.TJPrimitiveIterator_OfInt;
  TJPrimitiveIterator_OfLong = Androidapi.JNI.JavaTypes.TJPrimitiveIterator_OfLong;
  TJProperties = Androidapi.JNI.JavaTypes.TJProperties;
  TJRandom = Androidapi.JNI.JavaTypes.TJRandom;
  TJSpliterator = Androidapi.JNI.JavaTypes.TJSpliterator;
  TJSpliterator_OfPrimitive = Androidapi.JNI.JavaTypes.TJSpliterator_OfPrimitive;
  TJSpliterator_OfDouble = Androidapi.JNI.JavaTypes.TJSpliterator_OfDouble;
  TJSpliterator_OfInt = Androidapi.JNI.JavaTypes.TJSpliterator_OfInt;
  TJSpliterator_OfLong = Androidapi.JNI.JavaTypes.TJSpliterator_OfLong;
  TJTimeZone = Androidapi.JNI.JavaTypes.TJTimeZone;
  TJTimer = Androidapi.JNI.JavaTypes.TJTimer;
  TJTimerTask = Androidapi.JNI.JavaTypes.TJTimerTask;
  TJUUID = Androidapi.JNI.JavaTypes.TJUUID;
  TJAbstractExecutorService = Androidapi.JNI.JavaTypes.TJAbstractExecutorService;
  TJBlockingQueue = Androidapi.JNI.JavaTypes.TJBlockingQueue;
  TJCallable = Androidapi.JNI.JavaTypes.TJCallable;
  TJCountDownLatch = Androidapi.JNI.JavaTypes.TJCountDownLatch;
  TJDelayed = Androidapi.JNI.JavaTypes.TJDelayed;
  TJExecutor = Androidapi.JNI.JavaTypes.TJExecutor;
  TJExecutorService = Androidapi.JNI.JavaTypes.TJExecutorService;
  TJFuture = Androidapi.JNI.JavaTypes.TJFuture;
  TJRejectedExecutionHandler = Androidapi.JNI.JavaTypes.TJRejectedExecutionHandler;
  TJScheduledExecutorService = Androidapi.JNI.JavaTypes.TJScheduledExecutorService;
  TJScheduledFuture = Androidapi.JNI.JavaTypes.TJScheduledFuture;
  TJThreadPoolExecutor = Androidapi.JNI.JavaTypes.TJThreadPoolExecutor;
  TJScheduledThreadPoolExecutor = Androidapi.JNI.JavaTypes.TJScheduledThreadPoolExecutor;
  TJThreadFactory = Androidapi.JNI.JavaTypes.TJThreadFactory;
  TJTimeUnit = Androidapi.JNI.JavaTypes.TJTimeUnit;
  TJAtomicBoolean = Androidapi.JNI.JavaTypes.TJAtomicBoolean;
  TJAtomicReference = Androidapi.JNI.JavaTypes.TJAtomicReference;
  TJBiConsumer = Androidapi.JNI.JavaTypes.TJBiConsumer;
  TJBiFunction = Androidapi.JNI.JavaTypes.TJBiFunction;
  TJBinaryOperator = Androidapi.JNI.JavaTypes.TJBinaryOperator;
  TJConsumer = Androidapi.JNI.JavaTypes.TJConsumer;
  TJDoubleBinaryOperator = Androidapi.JNI.JavaTypes.TJDoubleBinaryOperator;
  TJDoubleConsumer = Androidapi.JNI.JavaTypes.TJDoubleConsumer;
  TJDoubleFunction = Androidapi.JNI.JavaTypes.TJDoubleFunction;
  TJDoublePredicate = Androidapi.JNI.JavaTypes.TJDoublePredicate;
  TJDoubleSupplier = Androidapi.JNI.JavaTypes.TJDoubleSupplier;
  TJDoubleToIntFunction = Androidapi.JNI.JavaTypes.TJDoubleToIntFunction;
  TJDoubleToLongFunction = Androidapi.JNI.JavaTypes.TJDoubleToLongFunction;
  TJDoubleUnaryOperator = Androidapi.JNI.JavaTypes.TJDoubleUnaryOperator;
  TJFunction = Androidapi.JNI.JavaTypes.TJFunction;
  TJIntBinaryOperator = Androidapi.JNI.JavaTypes.TJIntBinaryOperator;
  TJIntConsumer = Androidapi.JNI.JavaTypes.TJIntConsumer;
  TJIntFunction = Androidapi.JNI.JavaTypes.TJIntFunction;
  TJIntPredicate = Androidapi.JNI.JavaTypes.TJIntPredicate;
  TJIntSupplier = Androidapi.JNI.JavaTypes.TJIntSupplier;
  TJIntToDoubleFunction = Androidapi.JNI.JavaTypes.TJIntToDoubleFunction;
  TJIntToLongFunction = Androidapi.JNI.JavaTypes.TJIntToLongFunction;
  TJIntUnaryOperator = Androidapi.JNI.JavaTypes.TJIntUnaryOperator;
  TJLongBinaryOperator = Androidapi.JNI.JavaTypes.TJLongBinaryOperator;
  TJLongConsumer = Androidapi.JNI.JavaTypes.TJLongConsumer;
  TJLongFunction = Androidapi.JNI.JavaTypes.TJLongFunction;
  TJLongPredicate = Androidapi.JNI.JavaTypes.TJLongPredicate;
  TJLongSupplier = Androidapi.JNI.JavaTypes.TJLongSupplier;
  TJLongToDoubleFunction = Androidapi.JNI.JavaTypes.TJLongToDoubleFunction;
  TJLongToIntFunction = Androidapi.JNI.JavaTypes.TJLongToIntFunction;
  TJLongUnaryOperator = Androidapi.JNI.JavaTypes.TJLongUnaryOperator;
  TJObjDoubleConsumer = Androidapi.JNI.JavaTypes.TJObjDoubleConsumer;
  TJObjIntConsumer = Androidapi.JNI.JavaTypes.TJObjIntConsumer;
  TJObjLongConsumer = Androidapi.JNI.JavaTypes.TJObjLongConsumer;
  TJfunction_Predicate = Androidapi.JNI.JavaTypes.TJfunction_Predicate;
  TJSupplier = Androidapi.JNI.JavaTypes.TJSupplier;
  TJToDoubleFunction = Androidapi.JNI.JavaTypes.TJToDoubleFunction;
  TJToIntFunction = Androidapi.JNI.JavaTypes.TJToIntFunction;
  TJToLongFunction = Androidapi.JNI.JavaTypes.TJToLongFunction;
  TJUnaryOperator = Androidapi.JNI.JavaTypes.TJUnaryOperator;
  TJBaseStream = Androidapi.JNI.JavaTypes.TJBaseStream;
  TJCollector = Androidapi.JNI.JavaTypes.TJCollector;
  TJCollector_Characteristics = Androidapi.JNI.JavaTypes.TJCollector_Characteristics;
  TJDoubleStream = Androidapi.JNI.JavaTypes.TJDoubleStream;
  TJDoubleStream_Builder = Androidapi.JNI.JavaTypes.TJDoubleStream_Builder;
  TJIntStream = Androidapi.JNI.JavaTypes.TJIntStream;
  TJIntStream_Builder = Androidapi.JNI.JavaTypes.TJIntStream_Builder;
  TJLongStream = Androidapi.JNI.JavaTypes.TJLongStream;
  TJLongStream_Builder = Androidapi.JNI.JavaTypes.TJLongStream_Builder;
  TJStream = Androidapi.JNI.JavaTypes.TJStream;
  TJStream_Builder = Androidapi.JNI.JavaTypes.TJStream_Builder;
  TJCipher = Androidapi.JNI.JavaTypes.TJCipher;
  TJExemptionMechanism = Androidapi.JNI.JavaTypes.TJExemptionMechanism;
  TJMac = Androidapi.JNI.JavaTypes.TJMac;
  TJEGL = Androidapi.JNI.JavaTypes.TJEGL;
  TJEGL10 = Androidapi.JNI.JavaTypes.TJEGL10;
  TJEGLConfig = Androidapi.JNI.JavaTypes.TJEGLConfig;
  TJEGLContext = Androidapi.JNI.JavaTypes.TJEGLContext;
  TJEGLDisplay = Androidapi.JNI.JavaTypes.TJEGLDisplay;
  TJEGLSurface = Androidapi.JNI.JavaTypes.TJEGLSurface;
  TJGL = Androidapi.JNI.JavaTypes.TJGL;
  TJGL10 = Androidapi.JNI.JavaTypes.TJGL10;
  TJJSONArray = Androidapi.JNI.JavaTypes.TJJSONArray;
  TJJSONException = Androidapi.JNI.JavaTypes.TJJSONException;
  TJJSONObject = Androidapi.JNI.JavaTypes.TJJSONObject;
  TJJSONTokener = Androidapi.JNI.JavaTypes.TJJSONTokener;
  TJXmlPullParser = Androidapi.JNI.JavaTypes.TJXmlPullParser;
  TJXmlSerializer = Androidapi.JNI.JavaTypes.TJXmlSerializer;

  // jni bridge
  IJava = Androidapi.JNIBridge.IJava;
  IJavaClass = Androidapi.JNIBridge.IJavaClass;
  IJavaInstance = Androidapi.JNIBridge.IJavaInstance;
  TRawVTable = Androidapi.JNIBridge.TRawVTable;
  TJavaVTable = Androidapi.JNIBridge.TJavaVTable;
  EJNI = Androidapi.JNIBridge.EJNI;
  EJNIFatal = Androidapi.JNIBridge.EJNIFatal;
  ILocalObject = Androidapi.JNIBridge.ILocalObject;
  TJavaImport = Androidapi.JNIBridge.TJavaImport;
  TJInterfacedObject = Androidapi.JNIBridge.TJInterfacedObject;
  TJavaLocal = Androidapi.JNIBridge.TJavaLocal;
  TVTableCache = Androidapi.JNIBridge.TVTableCache;
  TClassLoader = Androidapi.JNIBridge.TClassLoader;
  TJavaValidate = Androidapi.JNIBridge.TJavaValidate;
  TJNIResolver = Androidapi.JNIBridge.TJNIResolver;
  JavaSignatureAttribute = Androidapi.JNIBridge.JavaSignatureAttribute;
  TJavaBasicArray = Androidapi.JNIBridge.TJavaBasicArray;
  TRegTypes = Androidapi.JNIBridge.TRegTypes;
//  TJavaArray<T> = Androidapi.JNIBridge.TJavaArray<T>;
//  TJavaObjectArray<T> = Androidapi.JNIBridge.TJavaObjectArray<T>;
//  TJavaBiArray<T> = Androidapi.JNIBridge.TJavaBiArray<T>;
//  TJavaObjectBiArray<T> = Androidapi.JNIBridge.TJavaObjectBiArray<T>;
//  TJavaGenericImport<C, T> = Androidapi.JNIBridge.TJavaGenericImport<C, T>;


  // Os
  JBundle = Androidapi.JNI.Os.JBundle;

  // Activity
  JActivity = Androidapi.JNI.App.JActivity;

  // Android helpers
  TAndroidHelper = Androidapi.Helpers.TAndroidHelper;

  // Activity lifecycle
  TPscLifecycleManager = Pisces.Lifecycle.TPscLifecycleManager;
  TPscActivityLifecycleListener = Pisces.Lifecycle.TPscActivityLifecycleListener;
  TPscViewLifecycleListener = Pisces.Lifecycle.TPscViewLifecycleListener;
  TPscWindowFocusChangeListener = Pisces.Lifecycle.TPscWindowFocusChangeListener;
  TPiscesApplication = Pisces.App.TPiscesApplication;

  // pisces helper types
  {$SCOPEDENUMS ON}

  TLayout = (MATCH, FILL, WRAP);
  TLytDirection = (INHERIT, LOCALE, LEFTTORIGHT, RIGHTTOLEFT);
  TLogger = (Info, Error, Warning, Fatal);
  TBreakStrg = (Balanced, HighQuality, Simple);
  THyphenStrg = (Full, None, Normal);
  TLineBreakStyle = (LineBreakNone, LineBreakLoose, LineBreakNormal, LineBreakStrict);
  TLineBreakWordStyle = (LineBreakWordNone, LineBreakWordPhrase);
  TAccessibilityLiveRegion = (None, Polite, Assertive);
  TDrawingCacheQuality = (Low, High, Auto);
  TOverScrollMode = (Always, IfContentScrolls, Never);
  TScrollIndicator = (Bottom, EndPos, Left, Right, Start, Top);
  TTextBuffer = (Editable, Normal, Spannable);
  TOrientation = (Horizontal, Vertical);
  TDescendantFocusability = (FocusAfterDescendants, FocusBeforeDescendants, FocusBlockDescendants);
  TImageScaleType = (FitCenter, CenterCrop, CenterInside);

  TReturnKeyType = (
    Done,
    Go,
    Next,
    Search,
    Send,
    Unspecified
  );

  TInputType = (
    Text,
    Number,
    Phone,
    DateTime,
    TextEmailAddress,
    TextPassword,
    TextVisiblePassword,
    TextWebEmailAddress,
    TextWebPassword,
    TextUri,
    TextPersonName,
    TextPostalAddress,
    TextMultiLine,
    NumberDecimal,
    NumberSigned,
    NumberPassword,
    Date,
    Time
  );

  TFocusableMode = (Focusable, FocusablesAll, FocusablesTouchMode, FocusableAuto,
    FocusBackward, FocusDown, FocusForward, FocusLeft, FocusRight, FocusUp, NotFocusable);

  TGravity = (AxisClip, AxisPullAfter, AxisPullBefore, AxisSpecified,
    AxisXShift, AxisYShift, Bottom, Center, CenterHorizontal, CenterVertical,
    ClipHorizontal, ClipVertical, DisplayClipHorizontal, DisplayClipVertical,
    EndPos, Fill, FillHorizontal, FillVertical, HorizontalGravityMask, Left,
    NoGravity, RelativeHorizontalGravityMask, RelativeLayoutDirection,
    Right, Start, Top, VerticalGravityMask);

  TSwipeDirection = (Left, Right, Up, Down, Touch, Leave);

  TGradientShape = (Linear, Radial, Sweep);

  TChoiceMode = (None, Single, Multiple);
  TAdapterType = (ArrayAdapter, ViewArrayAdapter);

  TGradientOrientation = (
    TopToBottom, LeftToRight, BottomToTop, RightToLeft, TopLeftToBottomRight,
    TopRightToBottomLeft, BottomLeftToTopRight, BottomRightToTopLeft);

  TFontStyle = (Normal, Bold, Italic, BoldItalic);

  TScreenOrientation = (
    Unspecified, Portrait, Landscape, SensorPortrait, SensorLandscape,
    ReverseLandscape, ReversePortrait, Sensor, NoSensor, Locked);

  TTransitionType = (
    None,           // No animation
    Fade,           // Alpha fade in/out
    SlideLeft,      // Slide from/to left
    SlideRight,     // Slide from/to right
    SlideUp,        // Slide from/to top
    SlideDown,      // Slide from/to bottom
    ScaleCenter,    // Scale from/to center
    FlipHorizontal, // 3D flip around Y-axis
    FlipVertical    // 3D flip around X-axis
  );

  TEasingType = (
    Linear,                // Constant rate
    AccelerateDecelerate,  // Slow start/end, fast middle
    Accelerate,            // Slow start, fast end
    Decelerate,            // Fast start, slow end
    Anticipate,            // Slight overshoot backward before forward
    Overshoot,             // Overshoots target then settles
    AnticipateOvershoot,   // Both anticipate and overshoot
    Bounce                 // Bounces at the end
  );

  {$SCOPEDENUMS OFF}

  TGravitySet = set of TGravity;
  TScrollIndicatorSet = set of TScrollIndicator;
  TAutoLink = (AutoLinkWeb, AutoLinkEmail, AutoLinkPhone, AutoLinkMap);
  TAutoLinkSet = set of TAutoLink;
  TPaintFlag = (PaintUnderline, PaintStrikeThrough);
  TPaintFlagSet = set of TPaintFlag;

  TProc<T1, T2, T3, T4, T5, T6, T7, T8, T9> = reference to procedure (
    Arg1: T1; Arg2: T2; Arg3: T3; Arg4: T4;
    Arg5: T5; Arg6: T6; Arg7: T7; Arg8: T8; Arg9: T9);

  TColorStop = record
    Red: Integer;
    Green: Integer;
    Blue: Integer;
    Alpha: Double;
    Position: Single;
    constructor Create(ARed, AGreen, ABlue: Integer; AAlpha: Double = 1.0; APosition: Single = -1);
  end;

  TColorStopArray = array of TColorStop;

  TPscTransitionConfig = record
    TransitionType: TTransitionType;
    Easing: TEasingType;
    DurationMs: Integer;
    class function Default: TPscTransitionConfig; static;
    class function Create(AType: TTransitionType;
      AEasing: TEasingType = TEasingType.AccelerateDecelerate;
      ADuration: Integer = 300): TPscTransitionConfig; static;
  end;

  TPscScreenTransitions = record
    EnterTransition: TPscTransitionConfig;
    ExitTransition: TPscTransitionConfig;
    PopEnterTransition: TPscTransitionConfig;
    PopExitTransition: TPscTransitionConfig;
    class function Default: TPscScreenTransitions; static;
    class function Create(AEnter, AExit, APopEnter, APopExit: TPscTransitionConfig): TPscScreenTransitions; static;
  end;

  TPscAlertDialogTheme = record
  private
    FThemeResId: Integer;
    FHasThemeResId: Boolean;
    FBackgroundColor: Integer;
    FHasBackgroundColor: Boolean;
    FTitleColor: Integer;
    FHasTitleColor: Boolean;
    FMessageColor: Integer;
    FHasMessageColor: Boolean;
    FButtonTextColor: Integer;
    FHasButtonTextColor: Boolean;
    FListItemTextColor: Integer;
    FHasListItemTextColor: Boolean;
    FListItemCheckColor: Integer;
    FHasListItemCheckColor: Boolean;
    class function MakeColor(Red, Green, Blue: Integer; Alpha: Double): Integer; static;
    class procedure ApplyListTheme(const ATheme: TPscAlertDialogTheme; const AListView: JListView); static;
  public
    class function Create: TPscAlertDialogTheme; static;
    function Theme(AThemeResId: Integer): TPscAlertDialogTheme;
    function BackgroundColor(Red, Green, Blue: Integer; Alpha: Double = 1.0): TPscAlertDialogTheme;
    function TitleColor(Red, Green, Blue: Integer; Alpha: Double = 1.0): TPscAlertDialogTheme;
    function MessageColor(Red, Green, Blue: Integer; Alpha: Double = 1.0): TPscAlertDialogTheme;
    function ButtonTextColor(Red, Green, Blue: Integer; Alpha: Double = 1.0): TPscAlertDialogTheme;
    function ListItemTextColor(Red, Green, Blue: Integer; Alpha: Double = 1.0): TPscAlertDialogTheme;
    function ListItemCheckColor(Red, Green, Blue: Integer; Alpha: Double = 1.0): TPscAlertDialogTheme;
    procedure ApplyTo(const Dialog: JAlertDialog);
    property HasThemeResId: Boolean read FHasThemeResId;
    property ThemeResId: Integer read FThemeResId;
  end;

implementation

type
  TPscAlertDialogListThemeRunnable = class(TJavaLocal, JRunnable)
  private
    FTheme: TPscAlertDialogTheme;
    FListView: JListView;
  public
    constructor Create(const ATheme: TPscAlertDialogTheme; const AListView: JListView);
    procedure run; cdecl;
  end;

{ TPscTransitionConfig }

class function TPscTransitionConfig.Default: TPscTransitionConfig;
begin
  Result.TransitionType := TTransitionType.Fade;
  Result.Easing := TEasingType.AccelerateDecelerate;
  Result.DurationMs := 300;
end;

class function TPscTransitionConfig.Create(AType: TTransitionType;
  AEasing: TEasingType; ADuration: Integer): TPscTransitionConfig;
begin
  Result.TransitionType := AType;
  Result.Easing := AEasing;
  Result.DurationMs := ADuration;
end;

{ TPscScreenTransitions }

class function TPscScreenTransitions.Default: TPscScreenTransitions;
begin
  Result.EnterTransition := TPscTransitionConfig.Default;
  Result.ExitTransition := TPscTransitionConfig.Default;
  Result.PopEnterTransition := TPscTransitionConfig.Default;
  Result.PopExitTransition := TPscTransitionConfig.Default;
end;

class function TPscScreenTransitions.Create(AEnter, AExit, APopEnter,
  APopExit: TPscTransitionConfig): TPscScreenTransitions;
begin
  Result.EnterTransition := AEnter;
  Result.ExitTransition := AExit;
  Result.PopEnterTransition := APopEnter;
  Result.PopExitTransition := APopExit;
end;

{ TColorStop }

constructor TColorStop.Create(ARed, AGreen, ABlue: Integer; AAlpha: Double; APosition: Single);
begin
  Red := ARed;
  Green := AGreen;
  Blue := ABlue;
  Alpha := AAlpha;
  Position := APosition;
  if (APosition >= 0) and (APosition <= 1) then
    Position := APosition
  else
    Position := -1;
end;

{ TPscAlertDialogTheme }

class function TPscAlertDialogTheme.Create: TPscAlertDialogTheme;
begin
  Result := Default(TPscAlertDialogTheme);
end;

class function TPscAlertDialogTheme.MakeColor(Red, Green, Blue: Integer; Alpha: Double): Integer;
begin
  if Alpha = 0 then
    Result := TJColor.JavaClass.TRANSPARENT
  else
    Result := TJColor.JavaClass.argb(Trunc(Alpha * 255), Red, Green, Blue);
end;

function TPscAlertDialogTheme.Theme(AThemeResId: Integer): TPscAlertDialogTheme;
begin
  Result := Self;
  Result.FThemeResId := AThemeResId;
  Result.FHasThemeResId := True;
end;

function TPscAlertDialogTheme.BackgroundColor(Red, Green, Blue: Integer; Alpha: Double): TPscAlertDialogTheme;
begin
  Result := Self;
  Result.FBackgroundColor := MakeColor(Red, Green, Blue, Alpha);
  Result.FHasBackgroundColor := True;
end;

function TPscAlertDialogTheme.TitleColor(Red, Green, Blue: Integer; Alpha: Double): TPscAlertDialogTheme;
begin
  Result := Self;
  Result.FTitleColor := MakeColor(Red, Green, Blue, Alpha);
  Result.FHasTitleColor := True;
end;

function TPscAlertDialogTheme.MessageColor(Red, Green, Blue: Integer; Alpha: Double): TPscAlertDialogTheme;
begin
  Result := Self;
  Result.FMessageColor := MakeColor(Red, Green, Blue, Alpha);
  Result.FHasMessageColor := True;
end;

function TPscAlertDialogTheme.ButtonTextColor(Red, Green, Blue: Integer; Alpha: Double): TPscAlertDialogTheme;
begin
  Result := Self;
  Result.FButtonTextColor := MakeColor(Red, Green, Blue, Alpha);
  Result.FHasButtonTextColor := True;
end;

function TPscAlertDialogTheme.ListItemTextColor(Red, Green, Blue: Integer; Alpha: Double): TPscAlertDialogTheme;
begin
  Result := Self;
  Result.FListItemTextColor := MakeColor(Red, Green, Blue, Alpha);
  Result.FHasListItemTextColor := True;
end;

function TPscAlertDialogTheme.ListItemCheckColor(Red, Green, Blue: Integer; Alpha: Double): TPscAlertDialogTheme;
begin
  Result := Self;
  Result.FListItemCheckColor := MakeColor(Red, Green, Blue, Alpha);
  Result.FHasListItemCheckColor := True;
end;

class procedure TPscAlertDialogTheme.ApplyListTheme(const ATheme: TPscAlertDialogTheme; const AListView: JListView);
var
  Child: JView;
  ItemView: JTextView;
  CheckedView: JCheckedTextView;
  CheckDrawable: JDrawable;
  Drawables: TJavaObjectArray<JDrawable>;
  i: Integer;
  j: Integer;
begin
  if AListView = nil then
    Exit;

  for i := 0 to AListView.getChildCount - 1 do
  begin
    Child := AListView.getChildAt(i);
    if Child = nil then
      Continue;

    if ATheme.FHasListItemTextColor then
    begin
      ItemView := TJTextView.Wrap(Child);
      if ItemView <> nil then
        ItemView.setTextColor(ATheme.FListItemTextColor);
    end;

    if ATheme.FHasListItemCheckColor then
    begin
      CheckedView := TJCheckedTextView.Wrap(Child);
      if CheckedView <> nil then
      begin
        CheckDrawable := CheckedView.getCheckMarkDrawable;
        if CheckDrawable <> nil then
          CheckDrawable.setTint(ATheme.FListItemCheckColor);
      end
      else
      begin
        ItemView := TJTextView.Wrap(Child);
        if ItemView <> nil then
        begin
          Drawables := ItemView.getCompoundDrawables;
          if Drawables <> nil then
            for j := 0 to Drawables.Length - 1 do
              if Drawables.Items[j] <> nil then
                Drawables.Items[j].setTint(ATheme.FListItemCheckColor);
        end;
      end;
    end;
  end;
end;

procedure TPscAlertDialogTheme.ApplyTo(const Dialog: JAlertDialog);
var
  Window: JWindow;
  Resources: JResources;
  TitleId: Integer;
  MessageId: Integer;
  TitleView: JTextView;
  MessageView: JTextView;
  PosButton: JButton;
  NegButton: JButton;
  NeuButton: JButton;
  ListId: Integer;
  ListView: JListView;
begin
  if Dialog = nil then
    Exit;

  if FHasBackgroundColor then
  begin
    Window := Dialog.getWindow;
    if Window <> nil then
      Window.setBackgroundDrawable(TJColorDrawable.JavaClass.init(FBackgroundColor));
  end;

  if FHasTitleColor or FHasMessageColor then
  begin
    Resources := TAndroidHelper.Context.getResources;
    if Resources <> nil then
    begin
      if FHasTitleColor then
      begin
        TitleId := Resources.getIdentifier(StringToJString('alertTitle'), StringToJString('id'), StringToJString('android'));
        if TitleId <> 0 then
        begin
          TitleView := TJTextView.Wrap(Dialog.findViewById(TitleId));
          if TitleView <> nil then
            TitleView.setTextColor(FTitleColor);
        end;
      end;

      if FHasMessageColor then
      begin
        MessageId := Resources.getIdentifier(StringToJString('message'), StringToJString('id'), StringToJString('android'));
        if MessageId <> 0 then
        begin
          MessageView := TJTextView.Wrap(Dialog.findViewById(MessageId));
          if MessageView <> nil then
            MessageView.setTextColor(FMessageColor);
        end;
      end;
    end;
  end;

  if FHasButtonTextColor then
  begin
    PosButton := Dialog.getButton(TJDialogInterface.JavaClass.BUTTON_POSITIVE);
    if PosButton <> nil then
      PosButton.setTextColor(FButtonTextColor);

    NegButton := Dialog.getButton(TJDialogInterface.JavaClass.BUTTON_NEGATIVE);
    if NegButton <> nil then
      NegButton.setTextColor(FButtonTextColor);

    NeuButton := Dialog.getButton(TJDialogInterface.JavaClass.BUTTON_NEUTRAL);
    if NeuButton <> nil then
      NeuButton.setTextColor(FButtonTextColor);
  end;

  if FHasListItemTextColor or FHasListItemCheckColor then
  begin
    ListView := Dialog.getListView;
    if ListView = nil then
    begin
      if Resources = nil then
        Resources := TAndroidHelper.Context.getResources;

      if Resources <> nil then
      begin
        ListId := Resources.getIdentifier(StringToJString('select_dialog_listview'), StringToJString('id'), StringToJString('android'));
        if ListId = 0 then
          ListId := Resources.getIdentifier(StringToJString('list'), StringToJString('id'), StringToJString('android'));

        if ListId <> 0 then
          ListView := TJListView.Wrap(Dialog.findViewById(ListId))
        else
          ListView := nil;
      end
      else
        ListView := nil;
    end;

    if ListView <> nil then
    begin
      ApplyListTheme(Self, ListView);
      ListView.post(TPscAlertDialogListThemeRunnable.Create(Self, ListView));
    end;
  end;
end;

{ TPscAlertDialogListThemeRunnable }

constructor TPscAlertDialogListThemeRunnable.Create(const ATheme: TPscAlertDialogTheme; const AListView: JListView);
begin
  inherited Create;
  FTheme := ATheme;
  FListView := AListView;
end;

procedure TPscAlertDialogListThemeRunnable.run;
begin
  TPscAlertDialogTheme.ApplyListTheme(FTheme, FListView);
end;

end.
