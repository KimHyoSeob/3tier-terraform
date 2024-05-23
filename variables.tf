variable "region" {
  description = "3tier 프로젝트의 VPC"
}
variable "access_key" {
  description = "액세스 키"
}
variable "secret_key" {
  description = "시크릿 키"
}

variable "az-1" {
  description = "가용영역 1번"
}

variable "az-2" {
  description = "가용영역 2번"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
}

variable "public_subnet1_cidr" {
  description = "퍼블릭 서브넷1 CIDR"
}

variable "public_subnet2_cidr" {
  description = "퍼블릭 서브넷2 CIDR"
}

variable "private_subnet1_cidr" {
  description = "프라이빗 서브넷1 CIDR"
}

variable "private_subnet2_cidr" {
  description = "프라이빗 서브넷2 CIDR"
}

variable "private_subnet3_cidr" {
  description = "프라이빗 서브넷3 CIDR"
}

variable "private_subnet4_cidr" {
  description = "프라이빗 서브넷4 CIDR"
}

variable "private_subnet5_cidr" {
  description = "프라이빗 서브넷5 CIDR"
}

variable "private_subnet6_cidr" {
  description = "프라이빗 서브넷6 CIDR"
}

variable "ami_id" {
  description = "시작템플릿 ami id"
}

variable "instance_type" {
  description = "인스턴스 사양"
}

variable "db_identifier" {
  description = "DB 식별 이름"
}

variable "db_allocated_storage" {
  description = "DB 스토리지 크기"
}

variable "db_name" {
  description = "DB 이름"
}

variable "db_user" {
  description = "DB 사용자"
}

variable "db_password" {
  description = "DB 비밀번호"
}

variable "db_engine" {
  description = "DB 엔진"
}

variable "db_engine_version" {
  description = "DB 엔진 버전"
}

variable "db_instance_class" {
  description = "DB 인스턴스 타입"
}
