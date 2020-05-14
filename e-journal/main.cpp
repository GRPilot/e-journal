#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "authorizationvalidator.h"
#include "SignupProfile.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<AuthorizationValidator>("loc.validator", 1, 0, "Validator");
    qmlRegisterType<SignupProfile>("loc.SignupProfile", 1, 0, "SignupHelper");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);


    engine.load(url);

    return app.exec();
}
