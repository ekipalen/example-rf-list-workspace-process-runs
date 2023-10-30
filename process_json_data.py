def process_json_data(result_json):
    table = []
    for process_run in result_json['data']:
        details = process_run.get('started_by', {}).get('details')
        if details is None:
            details_id = ''
            details_first_name = ''
            details_last_name = ''
        else:
            details_id = details.get('id', '')
            details_first_name = details.get('first_name', '')
            details_last_name = details.get('last_name', '')
        row = {
            'id': process_run.get('id'),
            'state': process_run.get('state'),
            'process.id': process_run.get('process', {}).get('id'),
            'process.name': process_run.get('process', {}).get('name'),
            'duration': process_run.get('duration'),
            'started_at': process_run.get('started_at'),
            'started_by.type': process_run.get('started_by', {}).get('type'),
            'started_by.details.id': details_id,
            'started_by.details.first_name': details_first_name,
            'started_by.details.last_name': details_last_name,
            'created_at': process_run.get('created_at'),
            'ended_at': process_run.get('ended_at')
        }
        table.append(row)
    return table