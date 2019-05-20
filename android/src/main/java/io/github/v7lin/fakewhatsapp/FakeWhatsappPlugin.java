package io.github.v7lin.fakewhatsapp;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.text.TextUtils;
import android.webkit.URLUtil;

import java.net.URL;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

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
    private static final String METHOD_SHAREWEBPAGE = "shareWebpage";

    private static final String ARGUMENT_KEY_TEXT = "text";
    private static final String ARGUMENT_KEY_IMAGEURI = "imageUri";
    private static final String ARGUMENT_KEY_WEBPAGEURL = "webpageUrl";

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
        } else if (TextUtils.equals(METHOD_SHAREWEBPAGE, call.method)) {
            shareWebpage(call, result);
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
        if (resolveIntent(registrar.context(), sendIntent, WHATSAPP_PACKAGE_NAME)) {
            sendIntent.setPackage(WHATSAPP_PACKAGE_NAME);
            registrar.activity().startActivity(sendIntent);
        }
        result.success(null);
    }

    private void shareImage(MethodCall call, Result result) {
        String imageUri = call.argument(ARGUMENT_KEY_IMAGEURI);
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_STREAM, Uri.parse(imageUri));
        sendIntent.setType("image/*");
        if (resolveIntent(registrar.context(), sendIntent, WHATSAPP_PACKAGE_NAME)) {
            registrar.context().grantUriPermission(WHATSAPP_PACKAGE_NAME, Uri.parse(imageUri), Intent.FLAG_GRANT_READ_URI_PERMISSION);
            sendIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            sendIntent.setPackage(WHATSAPP_PACKAGE_NAME);
            registrar.activity().startActivity(sendIntent);
        }
        result.success(null);
    }

    private void shareWebpage(MethodCall call, Result result) {
        String text = call.argument(ARGUMENT_KEY_TEXT);
        String webpageUrl = call.argument(ARGUMENT_KEY_WEBPAGEURL);
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_TEXT, !TextUtils.isEmpty(text) ? text + webpageUrl : webpageUrl);
        sendIntent.setType("text/*");
        if (resolveIntent(registrar.context(), sendIntent, WHATSAPP_PACKAGE_NAME)) {
            sendIntent.setPackage(WHATSAPP_PACKAGE_NAME);
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

    private boolean resolveIntent(Context context, Intent intent, String packageName) {
        List<ResolveInfo> resolveInfos = context.getPackageManager().queryIntentActivities(intent, 0);
        if (resolveInfos != null && !resolveInfos.isEmpty()) {
            for (ResolveInfo resolveInfo : resolveInfos) {
                if (TextUtils.equals(resolveInfo.activityInfo.packageName, packageName)) {
                    return true;
                }
            }
        }
        return false;
    }
}
