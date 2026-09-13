
-- Integrity constraints




-- SHUTTLE CONSTRAINTS


ALTER TABLE shuttle
ADD CONSTRAINT uq_shuttle_code
UNIQUE (shuttle_code);

ALTER TABLE shuttle
ADD CONSTRAINT chk_shuttle_capacity
CHECK (capacity > 0);

ALTER TABLE shuttle
ADD CONSTRAINT chk_shuttle_type
CHECK (shuttle_type IN ('4-seater', '8-seater', '12-seater'));

ALTER TABLE shuttle
ADD CONSTRAINT chk_shuttle_status
CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE'));



-- STATION CONSTRAINTS


ALTER TABLE station
ADD CONSTRAINT uq_station_name
UNIQUE (station_name);



-- ROUTE CONSTRAINTS


ALTER TABLE route
ADD CONSTRAINT uq_route_name
UNIQUE (route_name);



-- ROUTE_STOP CONSTRAINTS


ALTER TABLE route_stop
ADD CONSTRAINT uq_route_station
UNIQUE (route_id, station_id);

ALTER TABLE route_stop
ADD CONSTRAINT chk_route_stop_sequence
CHECK (stop_sequence > 0);



-- TRIP CONSTRAINTS


ALTER TABLE trip
ADD CONSTRAINT chk_trip_times
CHECK (end_time IS NULL OR end_time >= start_time);

ALTER TABLE trip
ADD CONSTRAINT chk_trip_status
CHECK (trip_status IN ('SCHEDULED', 'ACTIVE', 'COMPLETED', 'CANCELLED'));



-- TRIP_STOP CONSTRAINTS


ALTER TABLE trip_stop
ADD CONSTRAINT chk_trip_stop_sequence
CHECK (stop_sequence > 0);

ALTER TABLE trip_stop
ADD CONSTRAINT chk_trip_stop_planned_times
CHECK (
    planned_departure IS NULL
    OR planned_departure >= planned_arrival
);

ALTER TABLE trip_stop
ADD CONSTRAINT chk_trip_stop_actual_times
CHECK (
    actual_departure IS NULL
    OR actual_arrival IS NULL
    OR actual_departure >= actual_arrival
);


-- SHUTTLE_POSITION CONSTRAINTS

ALTER TABLE shuttle_position
ADD CONSTRAINT chk_position_speed
CHECK (speed_kmh IS NULL OR speed_kmh >= 0);

ALTER TABLE shuttle_position
ADD CONSTRAINT chk_position_heading
CHECK (
    heading IS NULL
    OR (heading >= 0 AND heading < 360)
);



-- PASSENGER CONSTRAINTS
-- (NOT NEEDED NOW)

-- BOOKING CONSTRAINTS


ALTER TABLE booking
ADD CONSTRAINT chk_booking_passenger_count
CHECK (passenger_count > 0);

ALTER TABLE booking
ADD CONSTRAINT chk_booking_time
CHECK (requested_pickup_time >= request_time);

ALTER TABLE booking
ADD CONSTRAINT chk_booking_different_stations
CHECK (pickup_station_id <> drop_station_id);

ALTER TABLE booking
ADD CONSTRAINT chk_booking_status
CHECK (
    booking_status IN (
        'PENDING',
        'ASSIGNED',
        'COMPLETED',
        'CANCELLED'
    )
);


-- OCCUPANCY_EVENT CONSTRAINTS

ALTER TABLE occupancy_event
ADD CONSTRAINT chk_occupancy_boarded
CHECK (passengers_boarded >= 0);

ALTER TABLE occupancy_event
ADD CONSTRAINT chk_occupancy_dropped
CHECK (passengers_dropped >= 0);

ALTER TABLE occupancy_event
ADD CONSTRAINT chk_occupancy_after_event
CHECK (occupancy_after_event >= 0);

ALTER TABLE occupancy_event
ADD CONSTRAINT chk_occupancy_event_activity
CHECK (
    passengers_boarded > 0
    OR passengers_dropped > 0
);