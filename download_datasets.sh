#!/bin/bash

# Setup dowload directory
DOWNLOAD_DIR='datasets'

# Setup API endpoint variables
API_BASE_URL='https://api.fina.org'
API_ENDPOINT='/fina/rankings/swimming/report/csv'

# Setup parameter variables
GENDERS=('F' 'M')
DISTANCES=('50' '100' '200' '400' '800' '1500')
STROKES=('FREESTYLE' 'BACKSTROKE' 'BREASTSTROKE' 'BUTTERFLY' 'FREESTYLE_RELAY' 'MEDLEY_RELAY')
POOL_CONFIGURATIONS=('SCM' 'LCM')
YEARS=('')
START_DATES=('01%2F01%2F2000')
END_DATES=('')
TIME_MODES=('ALL_TIMES')
REGION_IDS=('AMERICAS')
# Country ID for Jamaica
COUNTRY_IDS=('ae07eb0c-ece4-4ec9-8bf6-37fbfd5dc43d')
PAGE_SIZES=('200')

# Ensure download directory exists
if [[ -n "${DOWNLOAD_DIR}" ]]
then
  mkdir -p "${DOWNLOAD_DIR}"
fi

# Download CSV files
for gender in "${GENDERS[@]}"
do
  for distance in "${DISTANCES[@]}"
  do
    for stroke in "${STROKES[@]}"
    do
      for pool_configuration in "${POOL_CONFIGURATIONS[@]}"
      do
        for year in "${YEARS[@]}"
        do
          for start_date in "${START_DATES[@]}"
          do
            for end_date in "${END_DATES[@]}"
            do
              for time_mode in "${TIME_MODES[@]}"
              do
                for region_id in "${REGION_IDS[@]}"
                do
                  for country_id in "${COUNTRY_IDS[@]}"
                  do
                    for page_size in "${PAGE_SIZES[@]}"
                    do
                      curl -o "${DOWNLOAD_DIR}/fina-rankings-swimming-report-gender-${gender}-distance-${distance}-stroke-${stroke}-poolConfiguration-${pool_configuration}-year-${year}-startDate-${start_date}-endDate-${end_date}-timesMode-${time_mode}-regionId-${region_id}-countryId-${country_id}-pageSize-${page_size}.csv" \
                        "${API_BASE_URL}${API_ENDPOINT}?gender=${gender}&distance=${distance}&stroke=${stroke}&poolConfiguration=${pool_configuration}&year=${year}&startDate=${start_date}&endDate=${end_date}&timesMode=${time_mode}&regionId=${region_id}&countryId=${country_id}&pageSize=${page_size}"
                    done
                  done
                done
              done
            done
          done
        done
      done
    done
  done
done

# Cleanup failed downloads
for failed_download_file in $(grep -H '"error":"Internal Server Error"' ${DOWNLOAD_DIR}/*.csv | cut -d: -f1)
do
  echo "Deleting failed download file \"${failed_download_file}\""
  rm -f "${failed_download_file}"
done

# Remove empty files
for file_to_check in $(ls -1 ${DOWNLOAD_DIR}/*.csv)
do
  if [[ "$(cat ${file_to_check} | wc -l)" -le "1" ]]
  then
    echo "Deleting empty file ${file_to_check}"
    rm -f "${file_to_check}"
  fi
done
