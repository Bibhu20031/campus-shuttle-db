
-- Index definitions
-- PostgreSQL + PostGIS




-- SPATIAL INDEXES


-- Station locations
CREATE INDEX idx_station_location_gist
ON station
USING GIST (location);


-- Planned route geometries
CREATE INDEX idx_route_geometry_gist
ON route
USING GIST (route_geometry);


-- Actual shuttle positions
CREATE INDEX idx_shuttle_position_location_gist
ON shuttle_position
USING GIST (location);



-- TEMPORAL INDEXES


-- Useful for retrieving the latest/current position of a shuttle during a trip.
CREATE INDEX idx_shuttle_position_trip_time
ON shuttle_position (trip_id, recorded_at DESC);


-- Useful for temporal trip searches.
CREATE INDEX idx_trip_start_time
ON trip (start_time);


-- Useful for finding trip stops in chronological order.
CREATE INDEX idx_trip_stop_trip_sequence
ON trip_stop (trip_id, stop_sequence);



-- ROUTE / STATION RELATIONSHIPS


-- Useful for finding all routes containing a station.
CREATE INDEX idx_route_stop_station
ON route_stop (station_id);


-- Useful for finding all trip stops for a station.
CREATE INDEX idx_trip_stop_station
ON trip_stop (station_id);



-- BOOKING / TRIP RELATIONSHIPS


-- Finding bookings assigned to a particular trip.
CREATE INDEX idx_booking_assigned_trip
ON booking (assigned_trip_id);


-- Finding bookings for a particular pickup station.
CREATE INDEX idx_booking_pickup_station
ON booking (pickup_station_id);


-- Finding bookings based on requested pickup time.
CREATE INDEX idx_booking_requested_pickup_time
ON booking (requested_pickup_time);



-- OCCUPANCY EVENTS

-- Retrieving occupancy history for a trip chronologically.
CREATE INDEX idx_occupancy_event_trip_time
ON occupancy_event (trip_id, event_time DESC);


-- Finding occupancy events associated with a station.
CREATE INDEX idx_occupancy_event_station
ON occupancy_event (station_id);