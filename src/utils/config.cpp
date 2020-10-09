// SPDX-License-Identifier: BSD-3-Clause
// Copyright (C) 2020 KeePassXC Team <team@keepassxc.org>
// Copyright (C) 2011 Felix Geyer <debfx@fobos.de>
// Copyright (C) 2020, The Monero Project.

#include "config.h"
#include "utils/utils.h"
#include "utils/tails.h"

#include <QCoreApplication>
#include <QDir>
#include <QStandardPaths>

#define QS QStringLiteral

struct ConfigDirective
{
    QString name;
    QVariant defaultValue;
};

static const QHash<Config::ConfigKey, ConfigDirective> configStrings = {
        // General
        {Config::warnOnExternalLink,{QS("warnOnExternalLink"), true}},
        {Config::checkForAppUpdates,{QS("checkForAppUpdates"), true}},
        {Config::warnOnStagenet,{QS("warnOnStagenet"), true}},
        {Config::warnOnTestnet,{QS("warnOnTestnet"), true}},
        {Config::warnOnAlpha,{QS("warnOnAlpha"), true}},
        {Config::homeWidget,{QS("homeWidget"), "ccs"}},
        {Config::donateBeg,{QS("donateBeg"), 1}},
        {Config::skin,{QS("skin"), "light"}},
        {Config::preferredFiatCurrency,{QS("preferredFiatCurrency"), "USD"}},
        {Config::blockExplorer,{QS("blockExplorer"), "exploremonero.com"}},
        {Config::walletDirectory,{QS("walletDirectory"), ""}},
        {Config::autoOpenWalletPath,{QS("autoOpenWalletPath"), ""}},
        {Config::walletPath,{QS("walletPath"), ""}},
        {Config::nodes,{QS("nodes"), "{}"}},
        {Config::websocketEnabled,{QS("websocketEnabled"), true}},
        {Config::nodeSource,{QS("nodeSource"), 0}},
        {Config::useOnionNodes,{QS("useOnionNodes"), false}},
        {Config::showTabCoins,{QS("showTabCoins"), false}},
        {Config::showTabXMRto,{QS("showTabXMRto"), true}},
        {Config::showTabCalc,{QS("showTabCalc"), true}},
        {Config::geometry, {QS("geometry"), {}}},
        {Config::windowState, {QS("windowState"), {}}},
        {Config::firstRun,{QS("firstRun"), false}},
};


QPointer<Config> Config::m_instance(nullptr);

QVariant Config::get(ConfigKey key)
{
    auto cfg = configStrings[key];
    auto defaultValue = configStrings[key].defaultValue;

    return m_settings->value(cfg.name, defaultValue);
}

QString Config::getFileName()
{
    return m_settings->fileName();
}

void Config::set(ConfigKey key, const QVariant& value)
{
    if (get(key) == value) {
        return;
    }

    auto cfg = configStrings[key];
    m_settings->setValue(cfg.name, value);

    this->sync();
    emit changed(key);
}

/**
 * Sync configuration with persistent storage.
 *
 * Usually, you don't need to call this method manually, but if you are writing
 * configurations after an emitted \link QCoreApplication::aboutToQuit() signal,
 * use it to guarantee your config values are persisted.
 */
void Config::sync()
{
    m_settings->sync();
}

void Config::resetToDefaults()
{
    m_settings->clear();
}

Config::Config(const QString& fileName, QObject* parent)
        : QObject(parent)
{
    init(fileName);
}

Config::Config(QObject* parent)
        : QObject(parent)
{
    QString configPath;

    bool isTails = TailsOS::detect();

    configPath = QDir::homePath();
    if (isTails) { // #if defined(PORTABLE)
        QString appImagePath = qgetenv("APPIMAGE");
        QFileInfo appImageDir(appImagePath);

        QDir portablePath(appImageDir.absoluteDir().path() + "/.feather");
        if (portablePath.mkpath(".")) {
            configPath = portablePath.path();
        }
        else {
            qCritical() << "Unable to create portable directory: " << portablePath.path();
        }
    }

    configPath += "/.config/feather/settings.json";

    init(QDir::toNativeSeparators(configPath));
}


Config::~Config()
{
}

void Config::init(const QString& configFileName)
{
    const QSettings::Format jsonFormat = QSettings::registerFormat("json", Utils::readJsonFile, Utils::writeJsonFile);
    QSettings::setDefaultFormat(jsonFormat);
    m_settings.reset(new QSettings(configFileName, jsonFormat));

    connect(qApp, &QCoreApplication::aboutToQuit, this, &Config::sync);
}

Config* Config::instance()
{
    if (!m_instance) {
        m_instance = new Config(qApp);
    }

    return m_instance;
}