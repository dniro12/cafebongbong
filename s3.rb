# all future examples assume this:
conn =
    S3::AWSAuthConnection.new("AKIAJNUMGOXYVYQD3ABA", "gXYbzOm2MTmgKThQkJWKWKp0acXD6iQTCpcHUpm")

response = conn.create_bucket("cafebongbong")
if response.http_response.code == 200
    print "Success"
else
    print "failed"
end