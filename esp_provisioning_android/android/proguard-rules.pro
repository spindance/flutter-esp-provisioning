-keepclassmembers,allowobfuscation class * {
 @com.google.gson.annotations.SerializedName <fields>;
}

-keep class com.spindance.esp_provisioning.model.** { *; }
-dontwarn com.espressif.provisioning.**
-dontwarn espressif.**
-keep class com.espressif.provisioning.** {*;}
-keepclassmembers class com.espressif.provisioning.** {*;}
-keep class espressif.** {*;}
-keepclassmembers class espressif.** {*;}
-keep interface com.espressif.provisioning.** {*;}
-keep interface espressif.** {*;}
-keep public enum com.espressif.provisioning.** {*;}
-keep public enum espressif.** {*;}