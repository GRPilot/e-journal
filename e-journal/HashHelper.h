#ifndef HASHHELPER_H
#define HASHHELPER_H

#include <QString>
#include <QCryptographicHash>

class HashHelper
{
    using Algorithm_t = QCryptographicHash::Algorithm;
    static const Algorithm_t m_defaultAlgorithmType = QCryptographicHash::Md5;
public:
    HashHelper(const QString &data, const Algorithm_t type = m_defaultAlgorithmType);

    QString hash() const;

    void setData(const QString &data);
    void setHash(const QString &hash);

private:
    QString m_data;
    QString m_hash;
    Algorithm_t m_type;
};

#endif // HASHHELPER_H
