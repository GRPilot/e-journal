#include "HashHelper.h"


HashHelper::HashHelper(const QString &data,
                       const Algorithm_t type)
    : m_data{ data },
      m_type{ type }
{
    setHash(m_data);
}

void HashHelper::setData(const QString &data) {
    m_data = data;
    setHash(m_data);
}

QString HashHelper::hash() const {
    return m_hash;
}

void HashHelper::setHash(const QString &hash){
    m_hash = QString{
        QCryptographicHash::hash((hash.toLocal8Bit()), m_type).toHex()
    };
}
