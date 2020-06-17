#include "ProfileInfo.h"

ProfileInfo::ProfileInfo(QObject *parent)
    : QObject(parent)
    , m_name    { "<username>"   }
    , m_subjects{ "<no items>"   }
    , m_groups  { "<no items>"   }
    , m_image   { "imgs/user"  }
    , m_imgPath { "imgs/user"  }
{}

ProfileInfo::ProfileInfo(const QString& username, QObject* parent)
    : ProfileInfo(parent)
{
    if(!setUsername(username))
        qDebug() << "Error! Cannot get user info!";
}

QString ProfileInfo::name() const {
    return m_name;
}

QString ProfileInfo::subjects() const {
    QString outstring{ stringsToString(m_subjects) };
    if (outstring == "<no items>")
        return outstring;

    outstring.prepend(" • ");
    return outstring.replace(", ", "\n • ");
}

QString ProfileInfo::groups() const {
    return stringsToString(m_groups);
}

QString ProfileInfo::image() const {
    return QString{ "file:///" + m_imgPath };
}

bool ProfileInfo::clearUserData() {
    m_name.clear();
    m_subjects.clear();
    m_groups.clear();

    bool status{ QFile::remove(m_imgPath) };
    m_imgPath = ":/imgs/user";

    return status;
}

bool ProfileInfo::setUsername(const QString& username) {
    using profile_t = ProfileData::Profile_type;

    if (username.isEmpty())
        return false;

    ProfileData data{ username.toLower() };
    profile_t curProfile{ data.currentProfile() };

    m_name     = curProfile.mName;
    m_subjects = curProfile.mSubjects;
    m_groups   = curProfile.mGroups;
    m_image    = curProfile.mProfileImg;

    if (!m_image.isNull())
        saveImg();

    return true;
}

bool ProfileInfo::saveImg()
{
    QFile file("tempImg.jpg");
    file.open(QIODevice::WriteOnly);

    m_imgPath = QString{"%1/%2"}
                .arg(QDir::currentPath())
                .arg("tempImg.jpg");

    bool status{ m_image.save(&file, "JPG") };

    file.close();
    return status;
}

QString ProfileInfo::stringsToString(const ProfileInfo::Strings& strings) const {
    if (strings.size() == 1)
        return strings.back();

    if (auto size{strings.size()}; size >= 2) {
        QString outstr;

        for (unsigned count{}; count < size; ++count) {
            if (count != size - 1)
                outstr.append("%").append(QString::number(count + 1)).append(", ");
            else
                outstr.append("%").append(QString::number(count + 1));
        }

        for (auto item : strings)
            outstr = outstr.arg(item);

        return outstr;
    }

    return QString{"<no items>"};
}
