
-- Campus Shuttle / E-Vehicle Database
-- TABLE CREATION



-- 1. SHUTTLE


CREATE TABLE shuttle (
    shuttle_id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shuttle_code    VARCHAR(20) NOT NULL,
    shuttle_type    VARCHAR(20) NOT NULL,
    capacity        INTEGER NOT NULL,
    status          VARCHAR(20) NOT NULL
);



-- 2. STATION


CREATE TABLE station (
    station_id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    station_name    VARCHAR(100) NOT NULL,
    station_type    VARCHAR(30) NOT NULL,
    location        geometry(Point, 4326) NOT NULL
);



-- 3. ROUTE


CREATE TABLE route (
    route_id        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    route_name      VARCHAR(100) NOT NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    route_geometry  geometry(LineString, 4326) NOT NULL
);



-- 4. ROUTE_STOP


CREATE TABLE route_stop (
    route_id        INTEGER NOT NULL,
    station_id      INTEGER NOT NULL,
    stop_sequence   INTEGER NOT NULL,

    PRIMARY KEY (route_id, stop_sequence),

    FOREIGN KEY (route_id)
        REFERENCES route(route_id),

    FOREIGN KEY (station_id)
        REFERENCES station(station_id)
);



-- 5. TRIP


CREATE TABLE trip (
    trip_id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shuttle_id      INTEGER NOT NULL,
    route_id        INTEGER NOT NULL,
    start_time      TIMESTAMP NOT NULL,
    end_time        TIMESTAMP,
    trip_status     VARCHAR(20) NOT NULL,

    FOREIGN KEY (shuttle_id)
        REFERENCES shuttle(shuttle_id),

    FOREIGN KEY (route_id)
        REFERENCES route(route_id)
);



-- 6. TRIP_STOP


CREATE TABLE trip_stop (
    trip_id             INTEGER NOT NULL,
    station_id          INTEGER NOT NULL,
    stop_sequence       INTEGER NOT NULL,
    planned_arrival     TIMESTAMP NOT NULL,
    actual_arrival      TIMESTAMP,
    planned_departure   TIMESTAMP,
    actual_departure    TIMESTAMP,

    PRIMARY KEY (trip_id, stop_sequence),

    FOREIGN KEY (trip_id)
        REFERENCES trip(trip_id),

    FOREIGN KEY (station_id)
        REFERENCES station(station_id)
);



-- 7. SHUTTLE_POSITION


CREATE TABLE shuttle_position (
    position_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    trip_id         INTEGER NOT NULL,
    recorded_at     TIMESTAMP NOT NULL,
    location        geometry(Point, 4326) NOT NULL,
    speed_kmh       NUMERIC(6,2),
    heading         NUMERIC(6,2),

    FOREIGN KEY (trip_id)
        REFERENCES trip(trip_id)
);



-- 8. PASSENGER


CREATE TABLE passenger (
    passenger_id    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    passenger_name  VARCHAR(100) NOT NULL,
    passenger_type  VARCHAR(30)
);



-- 9. BOOKING


CREATE TABLE booking (
    booking_id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    passenger_id            INTEGER NOT NULL,
    pickup_station_id       INTEGER NOT NULL,
    drop_station_id         INTEGER NOT NULL,
    passenger_count         INTEGER NOT NULL,
    request_time            TIMESTAMP NOT NULL,
    requested_pickup_time   TIMESTAMP NOT NULL,
    assigned_trip_id        INTEGER,
    booking_status          VARCHAR(20) NOT NULL,

    FOREIGN KEY (passenger_id)
        REFERENCES passenger(passenger_id),

    FOREIGN KEY (pickup_station_id)
        REFERENCES station(station_id),

    FOREIGN KEY (drop_station_id)
        REFERENCES station(station_id),

    FOREIGN KEY (assigned_trip_id)
        REFERENCES trip(trip_id)
);



-- 10. OCCUPANCY_EVENT


CREATE TABLE occupancy_event (
    event_id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    trip_id                 INTEGER NOT NULL,
    station_id              INTEGER NOT NULL,
    event_time              TIMESTAMP NOT NULL,
    passengers_boarded      INTEGER NOT NULL,
    passengers_dropped      INTEGER NOT NULL,
    occupancy_after_event   INTEGER NOT NULL,

    FOREIGN KEY (trip_id)
        REFERENCES trip(trip_id),

    FOREIGN KEY (station_id)
        REFERENCES station(station_id)
);