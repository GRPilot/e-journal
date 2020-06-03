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
 public:
    explicit ProfileInfo(QObject *parent = nullptr);
    explicit ProfileInfo(const QString& username,
                         QObject *parent = nullptr);

    Q_INVOKABLE QString name()     const;
    Q_INVOKABLE QString subjects() const;
    Q_INVOKABLE QString groups()   const;
    Q_INVOKABLE QImage  image()    const;

    Q_INVOKABLE bool    setUsername(const QString& username);

private:
    QString m_name;
    Strings m_subjects;
    Strings m_groups;
    QBitmap m_image;

    QString stringsToString(const Strings& strings) const;
};

