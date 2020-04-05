#ifndef AUTHORIZATIONVALIDATOR_H
#define AUTHORIZATIONVALIDATOR_H

#include <QObject>
#include <QCryptographicHash>
#include "dbprovider.h"

class AuthorizationValidator : public QObject
{
    Q_OBJECT
 public:
    const int minimumLenghtForPasswords = 4;
    explicit AuthorizationValidator(QObject *parent = nullptr);
    ~AuthorizationValidator();
    bool checkUser(QString login, QString password) const;

 signals:

 public slots:

 private:
    DBProvider *db;
    QString getHash(const QString password) const;
    void addNewUser();
};

#endif // AUTHORIZATIONVALIDATOR_H
