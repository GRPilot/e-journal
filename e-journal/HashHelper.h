#ifndef HASHHELPER_H
#define HASHHELPER_H

#include <QString>
#include <QCryptographicHash>

class HashHelper
{
public:
    HashHelper(const QString &data);

    QString hash() const;

    void setData(const QString &data);
    void setHash(const QString &hash);

private:
    QString m_data;
    QString m_hash;
};

#endif // HASHHELPER_H
