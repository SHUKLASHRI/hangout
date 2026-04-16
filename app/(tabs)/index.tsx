import React, { useState, useMemo } from 'react';
import { StyleSheet, View, Text, TouchableOpacity, SafeAreaView, Dimensions } from 'react-native';
import MapView, { Marker, Callout } from 'react-native-maps';
import { StatusBar } from 'expo-status-bar';
import { Filter, Search, Plus, Map as MapIcon, Calendar } from 'lucide-react-native';
import { Colors, Spacing, BorderRadius, Typography } from '../../theme';
import { SEEDED_HANGOUTS, Hangout } from '../../utils/seedData';
import { useAuth } from '../../context/AuthContext';
import { isWithinInterval, addHours, addDays, startOfToday, endOfToday, parseISO } from 'date-fns';
import { useRouter } from 'expo-router';

const { width, height } = Dimensions.get('window');

type TimeFilter = '1h' | '3h' | 'today' | 'week';

export default function HomeScreen() {
  const { user, isGuest } = useAuth();
  const [filter, setFilter] = useState<TimeFilter>('today');
  const router = useRouter();
  
  const filteredHangouts = useMemo(() => {
    const now = new Date();
    return SEEDED_HANGOUTS.filter(h => {
      const start = parseISO(h.startTime);
      switch (filter) {
        case '1h':
          return isWithinInterval(start, { start: now, end: addHours(now, 1) });
        case '3h':
          return isWithinInterval(start, { start: now, end: addHours(now, 3) });
        case 'today':
          return isWithinInterval(start, { start: startOfToday(), end: endOfToday() });
        case 'week':
          return isWithinInterval(start, { start: now, end: addDays(now, 7) });
        default:
          return true;
      }
    });
  }, [filter]);

  return (
    <View style={styles.container}>
      <StatusBar style="light" />
      
      <MapView
        style={styles.map}
        initialRegion={{
          latitude: 12.9716,
          longitude: 77.5946,
          latitudeDelta: 0.0922,
          longitudeDelta: 0.0421,
        }}
        customMapStyle={mapStyle}
      >
        {filteredHangouts.map((hangout) => (
          <Marker
            key={hangout.id}
            coordinate={{
              latitude: hangout.location.lat,
              longitude: hangout.location.lng,
            }}
            pinColor={Colors.secondary}
          >
            <Callout tooltip>
              <View style={styles.calloutContainer}>
                <Text style={styles.calloutTitle}>{hangout.title}</Text>
                <Text style={styles.calloutCategory}>{hangout.category}</Text>
                <Text style={styles.calloutTime}>
                  {new Date(hangout.startTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                </Text>
              </View>
            </Callout>
          </Marker>
        ))}
      </MapView>

      <SafeAreaView style={styles.header}>
        <View style={styles.searchBar}>
          <Search size={20} color={Colors.textMuted} />
          <Text style={styles.searchPlaceholder}>Search for hangouts...</Text>
        </View>

        <View style={styles.filterContainer}>
          {(['1h', '3h', 'today', 'week'] as TimeFilter[]).map((f) => (
            <TouchableOpacity
              key={f}
              style={[styles.filterChip, filter === f && styles.filterChipActive]}
              onPress={() => setFilter(f)}
            >
              <Text style={[styles.filterText, filter === f && styles.filterTextActive]}>
                {f.toUpperCase()}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </SafeAreaView>

      {!user && !isGuest && (
        <View style={styles.guestBanner}>
          <Text style={styles.guestText}>Join hangouts and meet new people!</Text>
          <TouchableOpacity 
            style={styles.loginButton}
            onPress={() => router.push('/auth/login')}
          >
            <Text style={styles.loginButtonText}>Sign In / Up</Text>
          </TouchableOpacity>
        </View>
      )}

      {user && (
        <TouchableOpacity 
          style={styles.fab}
          onPress={() => router.push('/hangout/create')}
        >
          <Plus size={30} color={Colors.white} />
        </TouchableOpacity>
      )}
    </View>
  );
}

const mapStyle = [
  {
    "elementType": "geometry",
    "stylers": [{ "color": "#242f3e" }]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{ "color": "#746855" }]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{ "color": "#242f3e" }]
  },
  // ... more styles for a dark theme map
];

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  map: {
    width: '100%',
    height: '100%',
  },
  header: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    padding: Spacing.md,
    backgroundColor: 'rgba(15, 23, 42, 0.8)',
  },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.surface,
    padding: Spacing.sm,
    borderRadius: BorderRadius.lg,
    gap: Spacing.sm,
    marginBottom: Spacing.sm,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  searchPlaceholder: {
    color: Colors.textMuted,
    ...Typography.body,
  },
  filterContainer: {
    flexDirection: 'row',
    gap: Spacing.sm,
  },
  filterChip: {
    paddingHorizontal: Spacing.md,
    paddingVertical: Spacing.xs,
    borderRadius: BorderRadius.full,
    backgroundColor: Colors.surface,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  filterChipActive: {
    backgroundColor: Colors.primary,
    borderColor: Colors.primary,
  },
  filterText: {
    color: Colors.textMuted,
    fontSize: 12,
    fontWeight: '600',
  },
  filterTextActive: {
    color: Colors.white,
  },
  calloutContainer: {
    backgroundColor: Colors.surface,
    padding: Spacing.md,
    borderRadius: BorderRadius.lg,
    width: 200,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  calloutTitle: {
    color: Colors.white,
    fontWeight: 'bold',
    fontSize: 14,
    marginBottom: 4,
  },
  calloutCategory: {
    color: Colors.secondary,
    fontSize: 12,
    marginBottom: 2,
  },
  calloutTime: {
    color: Colors.textMuted,
    fontSize: 12,
  },
  guestBanner: {
    position: 'absolute',
    bottom: Spacing.xl + 60,
    left: Spacing.md,
    right: Spacing.md,
    backgroundColor: Colors.surface,
    padding: Spacing.md,
    borderRadius: BorderRadius.xl,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderWidth: 1,
    borderColor: Colors.primary,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 8,
  },
  guestText: {
    color: Colors.text,
    fontSize: 14,
    fontWeight: '500',
    flex: 1,
    marginRight: Spacing.sm,
  },
  loginButton: {
    backgroundColor: Colors.primary,
    paddingHorizontal: Spacing.md,
    paddingVertical: Spacing.sm,
    borderRadius: BorderRadius.lg,
  },
  loginButtonText: {
    color: Colors.white,
    fontWeight: 'bold',
    fontSize: 12,
  },
  fab: {
    position: 'absolute',
    bottom: Spacing.xl + 60,
    right: Spacing.md,
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: Colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: Colors.primary,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.4,
    shadowRadius: 8,
    elevation: 8,
  },
});
