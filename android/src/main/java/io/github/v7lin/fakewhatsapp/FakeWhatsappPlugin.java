package io.github.v7lin.fakewhatsapp;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;

import androidx.core.content.FileProvider;

import java.io.File;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.github.v7lin.fakewhatsapp.content.FakeWhatsappFileProvider;

/**
 * FakeWhatsappPlugin
 */
public class FakeWhatsappPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "v7lin.github.io/fake_whatsapp");
        FakeWhatsappPlugin plugin = new FakeWhatsappPlugin(registrar);
        channel.setMethodCallHandler(plugin);
    }

    private static final String WHATSAPP_PACKAGE_NAME = "com.whatsapp";

    private static final String METHOD_ISWHATSAPPINSTALLED = "isWhatsappInstalled";
    private static final String METHOD_SHARETEXT = "shareText";
    private static final String METHOD_SHAREIMAGE = "shareImage";

    private static final String ARGUMENT_KEY_TEXT = "text";
    private static final String ARGUMENT_KEY_IMAGEURI = "imageUri";

    private final Registrar registrar;

    public FakeWhatsappPlugin(Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (TextUtils.equals(METHOD_ISWHATSAPPINSTALLED, call.method)) {
            result.success(isAppInstalled(registrar.context(), WHATSAPP_PACKAGE_NAME));
        } else if (TextUtils.equals(METHOD_SHARETEXT, call.method)) {
            shareText(call, result);
        } else if (TextUtils.equals(METHOD_SHAREIMAGE, call.method)) {
            shareImage(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void shareText(MethodCall call, Result result) {
        String text = call.argument(ARGUMENT_KEY_TEXT);
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_TEXT, text);
        sendIntent.setType("text/*");
        sendIntent.setPackage(WHATSAPP_PACKAGE_NAME);
        if (sendIntent.resolveActivity(registrar.context().getPackageManager()) != null) {
            registrar.activity().startActivity(sendIntent);
        }
        result.success(null);
    }

    private void shareImage(MethodCall call, Result result) {
        String imageUri = call.argument(ARGUMENT_KEY_IMAGEURI);
        Uri imageUrl = Uri.parse(imageUri);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            try {
                ProviderInfo providerInfo = registrar.context().getPackageManager().getProviderInfo(new ComponentName(registrar.context(), FakeWhatsappFileProvider.class), PackageManager.MATCH_DEFAULT_ONLY);
                imageUrl = FileProvider.getUriForFile(registrar.context(), providerInfo.authority, new File(imageUrl.getPath()));
            } catch (PackageManager.NameNotFoundException e) {
            }
        }
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_STREAM, imageUrl);
        sendIntent.setType("image/*");
        sendIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        sendIntent.setPackage(WHATSAPP_PACKAGE_NAME);
        if (sendIntent.resolveActivity(registrar.context().getPackageManager()) != null) {
            registrar.activity().startActivity(sendIntent);
        }
        result.success(null);
    }

    // ---

    private boolean isAppInstalled(Context context, String packageName) {
        PackageInfo packageInfo = null;
        try {
            packageInfo = context.getPackageManager().getPackageInfo(packageName, 0);
        } catch (PackageManager.NameNotFoundException e) {
        }
        return packageInfo != null;
    }
}
