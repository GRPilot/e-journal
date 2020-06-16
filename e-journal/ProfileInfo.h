/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * ProfileInfo служит связующим классом с qml отображением данных пользователя *
 *                                                                             *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#pragma once

#include <QObject>
#include <QBitmap>
#include <QDir>

#include "ProfileData.h"

class ProfileInfo : public QObject
{
    using Strings = std::vector<QString>;
    Q_OBJECT

    Q_PROPERTY(QString name     READ name)
    Q_PROPERTY(QString subjects READ subjects)
    Q_PROPERTY(QString groups   READ groups)
    Q_PROPERTY(QString image    READ image)

 public:
    explicit ProfileInfo(QObject *parent = nullptr);
    explicit ProfileInfo(const QString& username,
                         QObject *parent = nullptr);

    QString name()     const;
    QString subjects() const;
    QString groups()   const;
    QString image()    const;

    Q_INVOKABLE bool clearUserData();
    Q_INVOKABLE bool setUsername(const QString& username);

private:
    QString m_name;
    Strings m_subjects;
    Strings m_groups;
    QImage  m_image;
    QString m_imgPath;

    bool saveImg();

    QString stringsToString(const Strings& strings) const;
};

