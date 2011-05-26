DROP TABLE IF EXISTS timeline;
CREATE TABLE timeline (
    id CHAR(31) NOT NULL,
    user_id CHAR(31) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    text TEXT NOT NULL,
    profile_image_url VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);
CREATE INDEX timeline_user_id ON timeline (user_id);
CREATE INDEX timeline_timestamp ON timeline (timestamp);
