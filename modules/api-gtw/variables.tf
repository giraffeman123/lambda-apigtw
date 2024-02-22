variable "environment" {
    type = string 
    default = "dev"
}

variable "application" {
    type = string 
    default = "merge-sort"
}

variable "lambda_fn_name" {
    type = string 
    default = ""
}

variable "lambda_fn_invoke_arn" {
    type = string
    default = ""
}

variable "api_gtw_name" {
    type = string
}

variable "api_gtw_route" {
    type = string
}