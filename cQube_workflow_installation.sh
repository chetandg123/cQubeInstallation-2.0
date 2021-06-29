#!/bin/bash
config_file="./config.yml"
remove_config_file="./config.yml"
actual_output_file="../../Logs/installation_logs.txt"
services_output_file="../../Logs/services_logs.txt"
config_template="./config.yml.template"
new_config_file="./config.yml"
filled_config_file="../../ConfigFiles/Fill_workflow_installation_config_file.yml"
source_to_copy_infra_structure_master="../../ConfigFiles/infrastructure_master.csv"
destination_to_copy_infra_structure_master="../development/postgres/infrastructure_master.csv"
source_to_copy_infra_parameter_file="../../ConfigFiles/infra_parameters.txt"
destination_to_copy_infra_parameter_file="../development/python/infra_parameters.txt"
source_to_copy_cQube_raw_data_fetch_parameters_file="../../ConfigFiles/cQube-raw-data-fetch-parameters.txt"
destination_to_copy_cQube_raw_data_fetch_parameters_file="../development/python/cQube-raw-data-fetch-parameters.txt"
test_result_file="../../TestResult/installation_status_file.txt"
s3_access_key=$(awk ''/^s3_access_key:' /{ if ($2 !~ /#.*/) {print $2}}' ./ConfigFiles/workflow_installation_testing_config.yml)
s3_secret_key=$(awk ''/^s3_secret_key:' /{ if ($2 !~ /#.*/) {print $2}}' ./ConfigFiles/workflow_installation_testing_config.yml)
git_branch=$(awk ''/^git_branch:' /{ if ($2 !~ /#.*/) {print $2}}' ./ConfigFiles/workflow_installation_testing_config.yml)

remove_config_file()
{
  sudo rm "$remove_config_file"
}
copy_new_config_file()
{
  sudo cp $config_template $new_config_file
}
copy_filled_config_file()
{
  sudo cp $filled_config_file $new_config_file
}
copy_infrastructure_file()
{
  sudo cp $source_to_copy_infra_structure_master $destination_to_copy_infra_structure_master
}
remove_infrastructure_file()
{
  sudo rm $destination_to_copy_infra_structure_master
}
copy_infra_parameter_file()
{
  sudo cp $source_to_copy_infra_parameter_file $destination_to_copy_infra_parameter_file
}
remove_infra_parameter_file()
{
  sudo rm $destination_to_copy_infra_parameter_file
}
copy_cQube_raw_data_fetch_parameters_file()
{
  sudo cp $source_to_copy_cQube_raw_data_fetch_parameters_file $destination_to_copy_cQube_raw_data_fetch_parameters_file
}
remove_cQube_raw_data_fetch_parameters_file()
{
  sudo rm $destination_to_copy_cQube_raw_data_fetch_parameters_file
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
sudo git clone https://github.com/project-sunbird/cQube_Workflow.git
cd cQube_Workflow/
sudo git checkout $git_branch
cd workflow_deploy/
sudo cp config.yml.template config.yml
remove_infrastructure_file
copy_infrastructure_file
remove_infra_parameter_file
copy_infra_parameter_file
remove_cQube_raw_data_fetch_parameters_file
copy_cQube_raw_data_fetch_parameters_file
echo "${txtblue}Test Case:1********Checking error messages without filling config.yml testing is started**********""${txtrst}" >> "$test_result_file"
sudo sed -i 's/base_dir: \/opt/base_dir:/g' "$config_file"
sudo sed -i 's/diksha_columns: false /diksha_columns:/g' "$config_file"
sudo sed -i 's/session_timeout: 7D /session_timeout:/g' "$config_file"
printf 'yes\n' | sudo ./install.sh
printf 'yes\n' | sudo ./validate.sh | tee "$actual_output_file"

msg="Error - Please enter the absolute path or make sure the directory is present."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen} enter base_dir path message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}enter base_dir path message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking error messages without filling config.yml testing is completed**********" >> "$test_result_file"

echo "${txtblue}Test Case:2********Checking error messages without filling the base_dir path in config.yml testing is started**********""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/diksha_columns: false /diksha_columns:/g' "$config_file"
sudo sed -i 's/session_timeout: 7D /session_timeout:/g' "$config_file"
printf 'yes\n' | sudo ./validate.sh | tee "$actual_output_file"

msg="Error - in state_code. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}state_code error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}state_code error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in diksha_columns. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}diksha_columns error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}diksha_columns error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in static_datasource. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}static_datasource error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}static_datasource error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in management. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}management error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}management error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in session_timeout. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}session_timeout error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}session_timeout error message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking error messages without only filling the base_dir path in config.yml testing is started**********" >> "$test_result_file"

echo "${txtblue}Test Case:3********Checking state_code by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/state_code:/state_code: gujarath/g' "$config_file"
printf 'yes\n' | sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Invalid State code. Please refer the state_list file and enter the correct value."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid State code error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid State code errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking state_code by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:4********Checking diksha_columns by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/diksha_columns: false/diksha_columns: False/g' "$config_file"
printf 'yes\n' | sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Please enter either true or false for diksha_columns"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid diksha_columns error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid diksha_columns errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking diksha_columns by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:5********Checking static_datasource by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/static_datasource:/static_datasource: xyz/g' "$config_file"
printf 'yes\n' | sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Please enter either udise or state for static_datasource"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid static_datasource error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid static_datasource errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking static_datasource by passing invalid parameters testing is completed****************" >> "$test_result_file"


echo "${txtblue}Test Case:6********Checking session_timeout by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/session_timeout: 7D/session_timeout: 29M/g' "$config_file"
printf 'yes\n' | sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Minutes should be between 30 and 5256000"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid session_timeout error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid session_timeout errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking session_timeout by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:7********Checking session_timeout by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sudo sed -i 's/session_timeout: 7D/session_timeout: 3651D/g' "$config_file"
printf 'yes\n' | sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Days should be between 1 and 3650"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid session_timeout error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid session_timeout errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking session_timeout by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:8********Filling the valid parameters in the config.yml file testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_filled_config_file
printf 'yes\n' | sudo ./install.sh | tee "$actual_output_file"
output=$(grep -c "cQube Workflow installed successfully!!" $actual_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}cQube workflow installed successfully""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}cQube workflow is not installed successfully""${txtrst}" >> "$test_result_file"
fi
echo "********Filling the valid parameters in the config.yml file testing is completed****************" >> "$test_result_file"


echo "${txtblue}Test Case:9********Checking the gunicorn services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status gunicorn | tee "$services_output_file"
output=$(grep -c "running" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}gunicorn services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}gunicorn services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the gunicorn services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:10********Checking the postgres services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status postgresql.service | tee "$services_output_file"
output=$(grep -c "active (exited)" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}postgres services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}postgres services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the postgres services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:11********Checking the keycloak services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status keycloak.service | tee "$services_output_file"
output=$(grep -c "running" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}keycloak services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}keycloak services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the keycloak services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:12********Checking the grafana services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status grafana-server.service | tee "$services_output_file"
output=$(grep -c "running" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}grafana services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}grafana services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the grafana services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:13********Checking the kong services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status kong.service | tee "$services_output_file"
output=$(grep -c "running" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}kong services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}kong services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the kong services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:14********Checking the node_exporter services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status node_exporter.service | tee "$services_output_file"
output=$(grep -c "running" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}node_exporter services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}node_exporter services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the node_exporter services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:15********Checking the prometheus services testing is started****************""${txtrst}" >> "$test_result_file"
sudo systemctl status prometheus.service | tee "$services_output_file"
output=$(grep -c "running" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}prometheus services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}prometheus services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the prometheus services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:16********Checking the nifi services testing is started****************""${txtrst}" >> "$test_result_file"
sudo netstat -ntlp | grep 8096 | tee "$services_output_file"
output=$(grep -c "8096" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}nifi services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}nifi services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the nifi services testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:17********Checking the angular services testing is started****************""${txtrst}" >> "$test_result_file"
sudo netstat -ntlp | grep 3000 | tee "$services_output_file"
output=$(grep -c "3000" $services_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}angular services is running""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}angular services is not running""${txtrst}" >> "$test_result_file"
fi
echo "********Checking the angular services testing is completed****************" >> "$test_result_file"











