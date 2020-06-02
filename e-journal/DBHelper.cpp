#include "DBHelper.h"

DBHelper::DBHelper(const Tables table)
    : m_nameOfDB{ "e-journal-database" },
      m_path{ QDir::currentPath() + '/' + m_nameOfDB },
      m_currentTabel{ table }
{}

DBHelper &DBHelper::select_all() {
    return select(Values_t{"*"});
}

DBHelper &DBHelper::select(Values_t columns) {
   if (columns.empty())
        return *this;

    QString curTabel = currentTabel();
    QString cols = valuesToQString(columns);

    m_query = QString("SELECT %1 FROM %2 ")
              .arg(cols).arg(curTabel);

    return *this;
}

DBHelper &DBHelper::insert() {
    m_query = QString("INSERT INTO %1 ")
              .arg(currentTabel());

    return *this;
}

DBHelper &DBHelper::insert(Values_t columns) {
    if (columns.empty())
        return *this;

    QString curTabel = currentTabel();
    QString cols = valuesToQString(columns);

    m_query = QString("INSERT INTO %1(%2) ")
              .arg(curTabel).arg(cols);

    return *this;
}

DBHelper &DBHelper::update(Values_t values) {
    if (values.empty())
        return *this;

    QString curTabel = currentTabel();
    QString vals = valuesToQString(values);

    m_query = QString("UPDATE %1 SET %2 ")
              .arg(curTabel).arg(vals);

    return *this;
}

DBHelper &DBHelper::delete_from() {
    m_query = QString("DELETE FROM %1 ")
              .arg(currentTabel());

    return *this;
}

DBHelper &DBHelper::where(const QString condition) {
    if (condition.isEmpty() || condition.isNull())
        return *this;

    if (m_query.isEmpty() || m_query.isNull())
        return *this;


    m_query.append(QString("WHERE %2")
                   .arg(condition));
    return *this;
}

DBHelper &DBHelper::values(Values_t values) {
    if (values.empty() || m_query.isEmpty() || m_query.isNull())
        return *this;

    if (!m_query.contains("INSERT INTO"))
        return *this;

    QString vals = valuesToQString(values);

    m_query.append(QString("VALUES (%2) ")
                   .arg(vals));

    return *this;
}

void DBHelper::exist() {
    if (!m_query.contains("SELECT"))
        return;

    m_query.prepend("SELECT EXISTS (");
    m_query.append(")");
}

void DBHelper::clearQuery()  {
    m_query.clear();
}

QString DBHelper::currentTabel() const {
    switch (m_currentTabel) {
    case Tables::Groups:
        return QString("groups");
    case Tables::Marks:
        return QString("marks");
    case Tables::Students:
        return QString("students");
    case Tables::Subjects:
        return QString("students");
    case Tables::Teachers:
        return QString("teachers");
    case Tables::Users:
        return QString("users");

    default:
        return {};
    }
}


QString DBHelper::valuesToQString(Values_t vals) const {
    QString result{""};
    if (vals.empty())
        return result;

    if (vals.size() == 1)
        return vals.front();

    for (auto&& val : vals) {
        result += QString("%1").arg(val);
        result += val != vals.back() ? ", " : "";
    }

    return result;
}

QString DBHelper::query() const {
    if (m_query.isEmpty())
        return {};

    return m_query;
}

void DBHelper::setQuery(const QString& query) {
    if (!query.isEmpty())
        m_query = query;
    else
        m_query = "";
}

QString DBHelper::path() const {
    return m_path;
}
