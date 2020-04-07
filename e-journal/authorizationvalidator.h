#ifndef AUTHORIZATIONVALIDATOR_H
#define AUTHORIZATIONVALIDATOR_H

#include <QObject>
#include <QCryptographicHash>
#include "dbprovider.h"

class AuthorizationValidator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool checkUser READ checkUser READONLY)
 public:
    const int minimumLenghtForPasswords = 4;
    explicit AuthorizationValidator(QObject *parent = nullptr);
    ~AuthorizationValidator();

 signals:
    void sendToQml(bool isValid);

 public slots:
    bool checkUser(QString login, QString password) const;

 private:
    DBProvider *db;
    QString getHash(const QString password) const;
    void addNewUser();
};

#endif // AUTHORIZATIONVALIDATOR_H
