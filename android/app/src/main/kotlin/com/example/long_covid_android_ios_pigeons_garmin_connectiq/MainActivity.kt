package com.example.long_covid_android_ios_pigeons_garmin_connectiq

import android.os.Bundle
import android.util.Log
import android.widget.Toast
import com.garmin.android.connectiq.ConnectIQ
import com.garmin.android.connectiq.IQApp
import com.garmin.android.connectiq.IQDevice
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink

class MainActivity : FlutterActivity(), ConnectIQ.IQApplicationEventListener {
    private val channelName = "incrementerChannel"
    private lateinit var connectIQ: ConnectIQ
    private var events: EventSink? = null
    private var myApp: IQApp = IQApp("57fac8d8-ce06-4806-9df4-03ff0ea0836e")

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initializeConnectIQ()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, eventSink: EventSink) {
                    events = eventSink
                }

                override fun onCancel(arguments: Any?) {
                    events = null
                }
            }
        )
    }

    private fun initializeConnectIQ() {
        connectIQ = ConnectIQ.getInstance(applicationContext, ConnectIQ.IQConnectType.WIRELESS)
        connectIQ.initialize(applicationContext, true, object : ConnectIQ.ConnectIQListener {
            override fun onSdkReady() {
                connectIQ.knownDevices.forEach { device ->
                    connectIQ.registerForAppEvents(device, myApp, object : ConnectIQ.IQApplicationEventListener {
                        override fun onMessageReceived(
                            device: IQDevice?,
                            app: IQApp?,
                            message: MutableList<Any>,
                            status: ConnectIQ.IQMessageStatus?
                        ) {
                            if (status == ConnectIQ.IQMessageStatus.SUCCESS && message.isNotEmpty()) {
                                message.forEach { item ->
                                    (item as? Map<*, *>)?.let { map ->
                                        // Attempt to convert Map<*, *> to Map<String, Any> suitable for sending
                                        val safeMap = map.mapKeys { it.key.toString() }.mapValues { it.value ?: "Null Value" }
                                        events?.success(safeMap)
                                    }
                                }
                            }
                        }
                    })
                }
            }

            override fun onInitializeError(errStatus: ConnectIQ.IQSdkErrorStatus) {
                Toast.makeText(applicationContext, "Initialization Error: $errStatus", Toast.LENGTH_LONG).show()
            }

            override fun onSdkShutDown() {
                Toast.makeText(applicationContext, "SDK Shutdown", Toast.LENGTH_SHORT).show()
            }
        })
    }

    override fun onMessageReceived(
        p0: IQDevice?,
        p1: IQApp?,
        p2: MutableList<Any>?,
        p3: ConnectIQ.IQMessageStatus?
    ) {
        TODO("Not yet implemented")
    }
}
