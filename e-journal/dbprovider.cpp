#include "dbprovider.h"

DBProvider::DBProvider(const Tables table)
    : m_nameOfDB{ "e-journal-database" },
      m_currentTabel{ table },
      m_dbase(QSqlDatabase::addDatabase("QSQLITE"))
{
    m_dbase.setDatabaseName(QDir::currentPath() + '/' + m_nameOfDB);
    m_dbase.open();

    if (!m_dbase.isOpen()) {
        qDebug() << "[ERROR | SQLite] " << m_dbase.lastError().text();
        throw m_dbase.lastError();
    }
    m_dbase.close();
}

DBProvider::DBProvider(const DBProvider &other)
    : m_nameOfDB{ other.m_nameOfDB },
      m_currentTabel{ other.m_currentTabel },
      m_dbase{ other.m_dbase },
      m_query{ other.m_query },
      m_buildingQuery{ other.m_buildingQuery }
{

}

DBProvider *DBProvider::select_all() {
    return select(Val_List{"*"});
}

DBProvider *DBProvider::select(Val_List columns) {
    if (columns.empty())
        return this;

    QString curTabel = currentTabel();
    QString cols = valListToQString(columns);

    m_buildingQuery = QString("SELECT '%1' FROM %2 ")
            .arg(cols)
            .arg(curTabel);

    return this;
}

DBProvider *DBProvider::insert() {
    m_buildingQuery = QString("INSERT INTO %1 ").arg(currentTabel());
    return this;
}
DBProvider *DBProvider::insert(Val_List columns) {
    if (columns.empty())
        return this;

    QString curTabel = currentTabel();
    QString cols = valListToQString(columns);

    m_buildingQuery = QString("INSERT INTO %1(%2) ")
                      .arg(curTabel)
                      .arg(cols);

    return this;
}

DBProvider *DBProvider::update(Val_List values) {
    if (values.empty())
        return this;

    QString curTabel = currentTabel();
    QString vals = valListToQString(values);

    m_buildingQuery = QString("UPDATE %1 SET %2 ")
                      .arg(curTabel)
                      .arg(vals);

    return this;
}

DBProvider *DBProvider::delete_from() {
    m_buildingQuery = QString("DELETE FROM %1 ").arg(currentTabel());
    return this;
}

DBProvider *DBProvider::where(const QString condition) {
    if (condition.isEmpty() || condition.isNull())
        return this;

    if (m_buildingQuery.isEmpty() || m_buildingQuery.isNull())
        return nullptr;

    m_buildingQuery += QString("WHERE %1").arg(condition);
    return this;
}

DBProvider *DBProvider::values(Val_List values) {
    if (values.empty() || m_buildingQuery.isEmpty() || m_buildingQuery.isNull())
        return this;

    if (!m_buildingQuery.contains("INSERT INTO"))
        return this;

    QString vals = valListToQString(values);

    m_buildingQuery += QString("VALUES (%1) ").arg(vals);

    return this;
}

bool DBProvider::exist() {
    bool result{ false };
    if (!m_buildingQuery.contains("SELECT"))
        return result;

    m_buildingQuery = QString("SELECT EXISTS (%1)").arg(m_buildingQuery);
    m_dbase.open();
    m_query.exec(m_buildingQuery);

    if (m_query.next())
        result = m_query.value(0).toBool();

    m_dbase.close();

    return result;
}

bool DBProvider::exec() {
    QString buildQuery = buildingQuery();
    if (buildQuery.isEmpty() || buildQuery.isNull())
        return false;

    return m_query.exec(buildQuery);
}

int DBProvider::last_id() {
    QString curTabel = currentTabel();
    m_buildingQuery = QString("SELECT * FROM %1").arg(curTabel);
    m_query.exec(m_buildingQuery);
    int size = m_query.size();
    clearQuery();
    return size;
}

void DBProvider::clearQuery() {
    m_buildingQuery = "";
    m_query.clear();
}

QString DBProvider::currentTabel() const {
    switch (m_currentTabel) {
    case Groups:
        return QString("groups");
    case Marks:
        return QString("marks");
    case Students:
        return QString("students");
    case Subjects:
        return QString("students");
    case Teachers:
        return QString("teachers");
    case Users:
        return QString("users");

    default:
        return {};
    }
}

QString DBProvider::buildingQuery() const {
    return m_buildingQuery;
}

QSqlQuery DBProvider::query() const {
    return m_query;
}

QString DBProvider::valListToQString(Val_List vals) {
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
