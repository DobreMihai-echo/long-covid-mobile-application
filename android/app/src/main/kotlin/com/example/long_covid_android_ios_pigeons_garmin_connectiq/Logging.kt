package com.example.long_covid_android_ios_pigeons_garmin_connectiq

import android.util.Log

inline fun formatMessage(message: () -> String) =
    "[${Thread.currentThread().name}] ${message()}"

inline fun Any.logd(message: () -> String) {
    Log.d(this::class.java.simpleName, formatMessage(message))
    //println(message())
}

inline fun Any.loge(tr: Throwable? = null, message: () -> String) {
    Log.e(this::class.java.simpleName, formatMessage(message), tr)
    //println(message())
}

inline fun Any.logw(tr: Throwable? = null, message: () -> String) {
    Log.w(this::class.java.simpleName, formatMessage(message), tr)
    //println(message())
}