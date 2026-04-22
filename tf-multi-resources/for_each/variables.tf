variable "ec2-map" {
    description = "A map of EC2 instance configurations"
    type = map(object({
        ami           = string
        instance_type = string
        
    }))
   
}