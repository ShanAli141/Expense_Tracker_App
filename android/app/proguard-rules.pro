# Firebase IID - Prevents missing class issue with ML Kit
-keep class com.google.firebase.iid.** { *; }
-dontwarn com.google.firebase.iid.**

# ML Kit - Prevents removal of linked ML Kit classes
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Needed for ML Kit + Firebase Messaging integration
-keep class com.google.android.gms.internal.mlkit_vision_** { *; }
-dontwarn com.google.android.gms.internal.mlkit_vision_**

# General Firebase keep rules (optional)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# WorkManager keep rule if you're using background processing
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**
