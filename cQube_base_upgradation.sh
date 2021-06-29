#!/bin/bash
config_file="./upgradation_config.yml"
remove_config_file="./upgradation_config.yml"
actual_output_file="../Logs/upgradation_logs.txt"
services_output_file="../Logs/services_logs.txt"
config_template="./upgradation_config.yml.template"
new_config_file="./upgradation_config.yml"
filled_config_file="../ConfigFiles/Fill_base_upgradation_config_file.yml"
test_result_file="../TestResult/upgradation_status_file.txt"
s3_access_key=$(awk ''/^s3_access_key:' /{ if ($2 !~ /#.*/) {print $2}}' ./ConfigFiles/base_upgradation_testing_config.yml)
s3_secret_key=$(awk ''/^s3_secret_key:' /{ if ($2 !~ /#.*/) {print $2}}' ./ConfigFiles/base_upgradation_testing_config.yml)
git_branch=$(awk ''/^git_branch:' /{ if ($2 !~ /#.*/) {print $2}}' ./ConfigFiles/base_upgradation_testing_config.yml)

remove_config_file()
{
  rm "$remove_config_file"
}
copy_new_config_file()
{
  cp $config_template $new_config_file
}
copy_filled_config_file()
{
  cp $filled_config_file $new_config_file
}
remove_whitespace()
{
  value=$1
  after_removal_of_space=$(echo $value | tr -d ' ')
}
check_error_messages()
{
  while IFS= read -r line
  do
    actual_value=$(echo $line | tr -d ' ')
    expected_value=$1
    if [ $actual_value = $expected_value ]
    then
       return 1
    fi
  done < "$actual_output_file"

}
txtrst=$(tput sgr0) # Text reset
txtred=$(tput setaf 1) # Red
txtgreen=$(tput setaf 10) #green
txtblue=$(tput setaf 21) #blue

git clone https://github.com/project-sunbird/cQube_Base.git
cd cQube_Base/
sudo git checkout $git_branch
sudo git pull

sudo ./upgrade.sh | tee "$actual_output_file"

echo "${txtblue}Test Case:1********Checking the error message without copying upgradation_config.yml testing is started****************""${txtrst}" >> "$test_result_file"

msg="ERROR: config.yml is not available. Please copy upgradation_config.yml.template as config.yml and fill all the details."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}upgradation_config.yml is not available. error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}upgradation_config.yml is not available. error message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the error message without copying upgradation_config.yml testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:2********Checking error messages without filling upgradation_config.yml testing is started**********""${txtrst}" >> "$test_result_file"

cp config.yml.template config.yml
sudo ./upgrade.sh
sudo ./validate.sh | tee "$actual_output_file"

msg="Error - Please enter the absolute path or make sure the directory is present."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}enter the absolute path error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}enter the absolute path error message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking error messages without filling upgradation_config.yml testing is started**********" >> "$test_result_file"

echo "${txtblue}Test Case:3********Fill the base directory path and leave blank for rest of the config elements in the upgradation_config.yml testing is started**********""${txtrst}" >> "$test_result_file"
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"

msg="Error - in system_user_name. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}system_user_name error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}system_user_name error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in db_user. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}db_user error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}db_user error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in db_name. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}db_name error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}db_name error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in db_password. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}db_password error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}db_password error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in s3_access_key. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}s3_access_key error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}s3_access_key message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in s3_secret_key. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}s3_secret_key error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}s3_secret_key message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in s3_input_bucket. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}s3_input_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}s3_input_bucket message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in s3_output_bucket. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}s3_output_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}s3_output_bucket message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in s3_emission_bucket. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}s3_emission_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}s3_emission_bucket message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in api_endpoint. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}api_endpoint error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}api_endpoint message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in local_ipv4_address. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}local_ipv4_address error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}local_ipv4_address message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in vpn_local_ipv4_address. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}vpn_local_ipv4_address error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}vpn_local_ipv4_address message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in keycloak_adm_user. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}keycloak_adm_user error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}keycloak_adm_user message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in keycloak_adm_passwd. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}keycloak_adm_passwd error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}keycloak_adm_passwd message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in keycloak_config_otp. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}keycloak_config_otp error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}keycloak_config_otp message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Fill the base directory path and leave blank for rest of the config elements in the upgradation_config.yml testing is started****************" >> "$test_result_file"

echo "${txtblue}Test Case:3********Fill the invalid base directory path in the upgradation_config.yml testing is started**********""${txtrst}" >> "$test_result_file"
sed -i 's/base_dir:/base_dir: \/home/g' "$config_file"

msg="Error - Invalid base_dir or Unable to find the cQube in given base_dir"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid base_dir error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid base_dir error message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Fill the invalid base directory path in the upgradation_config.yml testing is completed**********" >> "$test_result_file"

echo "${txtblue}Test Case:4********Checking db_name db_user db_password by passing invalid parameters in the upgradation_config.yml testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/db_user:/db_user: cqube1/g' "$config_file"
sudo sed -i 's/db_name:/db_name: xyz/g' "$config_file"
sudo sed -i 's/db_password:/db_password: Tibil@123/g' "$config_file"

sudo ./validate.sh | tee "$actual_output_file"

msg="Error - db_user should be same as previous installation."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid db_user error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid db_user errors message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - db_name should be same as previous installation"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid db_name error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid db_name errors message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - Invalid Postgres credentials"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid Postgres credentials error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid Postgres credentials errors message is not displayed""${txtrst}" >> "$test_result_file"
fi

echo "********Checking db_name db_user db_password by passing invalid parameters in the upgradation_config.yml testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:5********Checking system_user_name by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/system_user_name:/system_user_name: xyz/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Please check the system_user_name."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid system_user_name error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid system_user_name errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking system_user_name by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:6********Checking s3_access_key & s3_secret_key by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/s3_access_key:/s3_access_key: AKIA2YWRVRZFEH7DOHEI/g' "$config_file"
sudo sed -i 's/s3_secret_key:/s3_secret_key: yHgZxIrdhuoDhLQmPsL6UyKDKrlMPjheFSgQt2gf/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Invalid aws access or secret keys"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid s3_access_key & s3_secret_key error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid s3_access_key & s3_secret_key errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking s3_access_key & s3_secret_key by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:7********Checking s3_input_bucket by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/s3_access_key:/s3_access_key: '$s3_access_key'/g' "$config_file"
sudo sed -i 's/s3_secret_key:/s3_secret_key: '$s3_secret_key'/g' "$config_file"
sudo sed -i 's/s3_input_bucket:/s3_input_bucket: cqube-z1-input/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - s3_input_bucket must be same as previously used bucket"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid s3_input_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid s3_input_bucket errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking s3_input_bucket by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:8********Checking s3_output_bucket by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/s3_access_key:/s3_access_key: '$s3_access_key'/g' "$config_file"
sudo sed -i 's/s3_secret_key:/s3_secret_key: '$s3_secret_key'/g' "$config_file"
sudo sed -i 's/s3_output_bucket:/s3_output_bucket: cqube-z1-output/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - s3_output_bucket must be same as previously used bucket"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid s3_output_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid s3_output_bucket errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking s3_output_bucket by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:9********Checking s3_emission_bucket by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/s3_access_key:/s3_access_key: '$s3_access_key'/g' "$config_file"
sudo sed -i 's/s3_secret_key:/s3_secret_key: '$s3_secret_key'/g' "$config_file"
sudo sed -i 's/s3_emission_bucket:/s3_emission_bucket: cqube-z1-emission/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - s3_emission_bucket must be same as previously used bucket"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid s3_emission_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid s3_emission_bucket errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking s3_emission_bucket by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:10********Checking api_endpoint by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/api_endpoint:/api_endpoint: cqube.tibilprojects.com/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Change in domain name. Please verify the api_endpoint"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}change in domain name error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}change in domain name errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking api_endpoint by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:11********Checking local_ipv4_address by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/local_ipv4_address:/local_ipv4_address: 172.31.11/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Invalid value for local_ipv4_address"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid local_ipv4_address error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid local_ipv4_address errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking local_ipv4_address by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:12********Checking vpn_local_ipv4_address by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/vpn_local_ipv4_address:/vpn_local_ipv4_address: 172.31.11/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Invalid value for vpn_local_ipv4_address"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid vpn_local_ipv4_address error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid vpn_local_ipv4_address errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking vpn_local_ipv4_address by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:13********Checking keycloak_adm_user by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/keycloak_adm_user:/keycloak_adm_user: xyz123/g' "$config_file"
sudo sed -i 's/keycloak_adm_user:/keycloak_adm_user: Tibil@123/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Invalid keycloak user or password."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid keycloak_adm_user error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid keycloak_adm_user errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking keycloak_adm_user by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:14********Checking keycloak_adm_passwd by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/keycloak_adm_user:/keycloak_adm_user: admin/g' "$config_file"
sudo sed -i 's/keycloak_adm_passwd:/keycloak_adm_passwd: tibil@123/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Invalid keycloak user or password"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid keycloak_adm_passwd error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid keycloak_adm_passwd errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking keycloak_adm_passwd by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:15********Checking keycloak_config_otp by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/base_dir:/base_dir: \/opt/g' "$config_file"
sudo sed -i 's/keycloak_config_otp:/keycloak_config_otp: False/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Please enter either true or false for keycloak_config_otp"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid keycloak_config_otp error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid keycloak_config_otp errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking keycloak_config_otp by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:16********Filling the valid parameters in the config.yml file testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_filled_config_file
sudo ./upgrade.sh | tee "$actual_output_file"
output=$(grep -c "cQube Base upgraded successfully!!" $actual_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}cQube base upgraded successfully""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}cQube base is not upgraded successfully""${txtrst}" >> "$test_result_file"
fi
echo "********Filling the valid parameters in the config.yml file testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:17********Checking the postgres services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status postgresql.service | tee "$services_output_file"
output=$(grep -c "active (exited)" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}postgres services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}postgres services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the postgres services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:18********Checking the kong services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status kong.service | tee "$services_output_file"
output=$(grep -c "running" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}kong services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}kong services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the kong services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:19********Checking the keycloak services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status keycloak.service | tee "$services_output_file"
output=$(grep -c "running" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}keycloak services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}keycloak services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the keycloak services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:20********Checking the prometheus services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status prometheus.service | tee "$services_output_file"
output=$(grep -c "running" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}prometheus services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}prometheus services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the prometheus services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:21********Checking the grafana services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status grafana-server.service | tee "$services_output_file"
output=$(grep -c "running" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}grafana services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}grafana services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the grafana services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:22********Checking the nifi services testing is started****************""${txtrst}" >> "$test_result_file"
sudo netstat -ntlp | grep 8096 | tee "$services_output_file"
output=$(grep -c "8096" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}nifi services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}nifi services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the nifi services testing is completed****************" >> "$test_result_file"

#echo "${txtblue}Test Case:23********Checking the angular services testing is started****************""${txtrst}" >> "$test_result_file"
#sudo netstat -ntlp | grep 3000 | tee "$services_output_file"
#output=$(grep -c "3000" $services_output_file)
#if [ $output = 1 ]
#then
#  echo "${txtgreen}angular services is running""${txtrst}" >> "$test_result_file"
#else
#  echo "${txtred}angular services is not running""${txtrst}" >> "$test_result_file"
#fi
#echo "********Checking the angular services testing is completed****************" >> "$test_result_file"











