#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "AuthValidator.h"
#include "SignupProfile.h"
#include "ProfileInfo.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<AuthValidator>("loc.validator",     1, 0, "Validator"   );
    qmlRegisterType<SignupProfile>("loc.SignupProfile", 1, 0, "SignupHelper");
    qmlRegisterType<ProfileInfo>  ("loc.ProfileInfo"  , 1, 0, "ProfileInfo" );

    const QUrl url(QStringLiteral("qrc:/SignInWindow.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
