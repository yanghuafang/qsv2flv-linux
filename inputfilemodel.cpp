#include "inputfilemodel.h"

#include <QFileInfo>

InputFileModel::InputFileModel()
    : info(), statusCode(STATUS_NONE), progress(0) {}

InputFileModel::InputFileModel(const QString& path) : info(path) {
  statusCode = STATUS_WAITING;
  progress = 0;
}

QString InputFileModel::getFilePath() const { return info.absoluteFilePath(); }

QString InputFileModel::getFileBaseName() const { return info.baseName(); }

QString InputFileModel::getFileName() const { return info.fileName(); }

InputFileModel::FileStatus InputFileModel::getStatusCode() const {
  return statusCode;
}

void InputFileModel::setStatusCode(InputFileModel::FileStatus value) {
  statusCode = value;
}

QString InputFileModel::getStatusMsg() const {
  switch (statusCode) {
    case STATUS_WAITING:
      return "Waiting";
    case STATUS_PROCESSING:
      return QString("Converting %1%").arg(100 * progress, 0, 'g', 3);
    case STATUS_SUCCEEDED:
      return "Completed";
    case STATUS_FAILED:
      return QString("Error: %1").arg(statusMsg);
    default:
      return "Unknown error";
  }
}

void InputFileModel::setStatusMsg(const QString& value) { statusMsg = value; }

void InputFileModel::setProgress(float value) { progress = value; }
