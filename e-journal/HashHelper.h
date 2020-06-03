/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * HashHelper существует только для удобного получения хэша строки в любом     *
 * месте данного проекта. Создан исключительно для ускорение процесса          *
 * разработки.                                                                 *
 *                                                                             *
 * c_defaultAlgorithm - стандартный алгоритм шифрования.                       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#pragma once

#include <QString>
#include <QCryptographicHash>

class HashHelper
{
    using Algorithm_t = QCryptographicHash::Algorithm;
    static const Algorithm_t c_defaultAlgorithm{ QCryptographicHash::Md5 };

 public:
    HashHelper(const QString& data,
               const Algorithm_t type = c_defaultAlgorithm);

    /// Получение хэша данных
    QString hash() const;

    /// Ввести новые данные
    void setData(const QString& data);

 private:
    QString     m_data;
    QString     m_hash;
    Algorithm_t m_type;

    /// Создать хэш из аргумента
    void setHash(const QString& hash);
};


