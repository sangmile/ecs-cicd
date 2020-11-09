variable "region" {
    default = "ap-northeast-2"
    description = "AWS Region"
}

provider "aws" {
    profile = "cloudbiz"
    region = "ap-northeast-2"
}